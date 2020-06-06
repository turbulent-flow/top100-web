module AMQP
    class Client
        attr_accessor :connection, :channel, :exchange, :server_queue_name, :correlation_id, :lock,
                      :condition, :reply_queue, :response

        def initialize(server_queue_name)
           @connection = Bunny.new
           @connection.start
           @channel = connection.create_channel
           @exchange = channel.default_exchange
           @server_queue_name = server_queue_name
           setup_reply_queue
        end

        def stop
            channel.close
            connection.close
        end

        # params e.g., {action: "find_products", category_id: 2, page: 1}
        def call(**params)
            @correlation_id = generate_uuid
            puts "correlation_id: #{correlation_id}"
            message = "#{params[:action]}/#{params[:category_id].to_s}/#{params[:page]}"
            puts "message: #{message}"
            puts "reply_queue: #{reply_queue.name}"
            exchange.publish(message, 
                             routing_key: server_queue_name, 
                             correlation_id: correlation_id,
                             reply_to: reply_queue.name,
                             content_type: "application/json")
            # wait for the signal to continue the execution
            lock.synchronize { condition.wait(lock) }
            response
        end

        private

        def setup_reply_queue
            @lock = Mutex.new
            @condition = ConditionVariable.new
            that = self
            @reply_queue = channel.queue("", exclusive: true)
            reply_queue.subscribe do |_delivery_info, properties, payload|
                # debug
                if properties[:correlation_id] == that.correlation_id
                    # decode the json from the queue
                    that.response = JSON.parse(payload)
                    # sends the signal to continue the execution of #call
                    that.lock.synchronize { that.condition.signal }
                end
            end
        end

        def generate_uuid
            "#{rand}#{rand}#{rand}"
        end
    end
end

require "bunny"
