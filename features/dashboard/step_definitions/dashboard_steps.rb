require "#{Rails.root}/lib/amqp"
require "#{Rails.root}/lib/top100_ranking"

Given(/^Top100Ranking filters '([^']*)' and return the following categories:$/) do |raw_filters, table|
    @request_payload = JSON.parse(raw_filters).symbolize_keys
    @categories = table
end

Given("also return the following products:") do |table|
    response_payload = {
        status: "success",
        data: {
            root_category: {
                id: 1,
                name: "Any Department"
            },
            selected_category_name: "Amazon Devices & Accessories",
            categories: @categories.hashes,
            products: table.hashes
        }
    }
    amqp = instance_double('AMQP::Client')
    allow(Top100Ranking::Client).to receive(:new).and_return(Top100Ranking::Client.new(client: amqp))
    allow(::AMQP::Client).to receive(:new).and_return(self)
    allow(amqp).to receive(:stop)
    request_payload = { server_queue_name: Top100Ranking::SERVER_QUEUE_NAME }.merge(@request_payload)
    response_payload = JSON.parse(response_payload.to_json)
    expect(amqp).to receive(:rpc).with("find_rankings", request_payload).and_return(response_payload)
end

When("I nvaigate to the dashboard") do
    visit "/categories/#{@request_payload[:category_id]}/page/#{@request_payload[:page]}"
end

Then("I should see the following categories:") do |table|
    columns = [ [ "name", ".category-name" ] ]
    dashboard_categories_diff(table, columns)
end

And("I should see the following products:") do |table|
    columns = [ ["rank", ".product-rank"], ["name", ".product-name"] ]
    dashboard_products_diff(table, columns)
end

When("I nvaigate to the dashboard with the portable device") do
    Capybara.default_driver = :selenium_chrome
    Capybara.page.current_window.resize_to(768, 1024)
    visit "/categories/#{@request_payload[:category_id]}/page/#{@request_payload[:page]}"
end

Then("I should not see any categories") do
    expected = "-250px"
    actual = page.evaluate_script(
        "window.getComputedStyle(document.querySelector('#slidebar')).getPropertyValue('margin-left')"
    ).to_s
    expect(actual).to eq(expected)
end
