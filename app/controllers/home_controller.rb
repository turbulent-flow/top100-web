class HomeController < ApplicationController
    include ::Top100Ranking

    def index
        client = Top100Ranking::Client.new
        @results = client.find_rankings(category_id: 2)
        logger.debug @results
    end
end

require "./lib/top100_ranking"
