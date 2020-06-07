module AMQP
    class Client
        def initialize
            @connection = Bunny.new
            connection.start
            @channel = connection.create_channel
        end

         # payload e.g.,
         # { server_queue_name: SERVER_QUEUE_NAME, category_id: category_id, page: page }
        def rpc(action, payload)
            exchange = channel.default_exchange
            mutex = Mutex.new
            condition = ConditionVariable.new
            reply_queue = channel.queue("", exclusive: true)
            response = nil
            reply_queue.subscribe do |_delivery_info, properties, payload|
                 # decode the json from the queue
                 response = JSON.parse(payload)
                 # sends the signal to continue the execution of #call
                 mutex.synchronize { condition.signal }
            end
            correlation_id = generate_uuid
            message = "#{action}/#{payload[:category_id].to_s}/#{payload[:page]}"
            options = { routing_key:  payload[:server_queue_name], correlation_id: correlation_id,
                        reply_to: reply_queue.name, content_type:  "application/json" }
            exchange.publish(message, options)
             begin
                 Timeout::timeout(5) { 
                    # wait for the signal to continue the execution
                    mutex.synchronize { condition.wait(mutex) }
                  }
             rescue Timeout::Error => _
                 raise "Unable to call #{action.inspect} with #{payload.inspect}: Time out!"
             end
             response
        end

        def stop
            channel.close
            connection.close
        end

        private

        def generate_uuid
            "#{rand}#{rand}#{rand}"
        end

        attr_reader :connection, :channel
    end
end

require "bunny"
