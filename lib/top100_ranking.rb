# The web client communicates with the microserver `top100-ranking` by useing RPC(remote procedure call) over the rabbitmq.

module Top100Ranking
    SERVER_QUEUE_NAME = "rpc_queue".freeze

    class Client
        attr_accessor :client

        def initialize(client: ::AMQP::Client.new(SERVER_QUEUE_NAME))
            @client = client
        end

        def find_products(category_id:, page: 1)
            params = { action: "find_products", category_id: category_id, page: page }
            response = client.call(params)
            puts "response: #{response}"
            finalize_amqp
            response
        end

        private

        def finalize_amqp
            client.stop
        end
    end
end

require "./lib/amqp"
