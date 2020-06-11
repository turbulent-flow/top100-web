require "#{Rails.root}/lib/top100_ranking"

class DashboardController < ApplicationController
    include ::Top100Ranking

    after_action :finalize

    def index
        category_id = params[:category_id].present? ?  params[:category_id] : 1
        page = params[:page].present? ? params[:page] : 1
        @client = Top100Ranking::Client.new
        results = @client.find_rankings(category_id: category_id, page: page)
        @data = results["data"]
    end

    private

    def finalize
        @client.finalize
    end
end
