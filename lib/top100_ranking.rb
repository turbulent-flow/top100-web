# The web client communicates with the microserver `top100-ranking` by useing RPC(remote procedure call) over the rabbitmq.

require "#{Rails.root}/lib/amqp"

module Top100Ranking
    SERVER_QUEUE_NAME = "rpc_queue".freeze

    class Client
        def initialize(client: ::AMQP::Client.new)
            @client = client
        end

        def find_rankings(category_id:, page: 1)
            payload = { server_queue_name: SERVER_QUEUE_NAME, 
                       category_id: category_id, page: page }
            response = client.rpc("find_rankings", payload)
        end

        def finalize
            client.stop
        end

        private

        attr_reader :client
    end
end
