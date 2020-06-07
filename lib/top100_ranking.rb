# The web client communicates with the microserver `top100-ranking` by useing RPC(remote procedure call) over the rabbitmq.

module Top100Ranking
    SERVER_QUEUE_NAME = "rpc_queue".freeze

    class Client
        def initialize(client: ::AMQP::Client.new)
            @client = client
        end

        def find_products(category_id:, page: 1)
            params = { server_queue_name: SERVER_QUEUE_NAME, 
                       category_id: category_id, page: page }
            response = client.rpc("find_products", params)
            finalize_amqp
            response
        end

        private

        def finalize_amqp
            client.stop
        end

        attr_reader :client
    end
end

require "./lib/amqp"
