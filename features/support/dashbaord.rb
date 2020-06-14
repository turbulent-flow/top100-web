module Dashboard
    # The fisrt element of the entry of the columns(its type is array) represents the name of the column.
    # The second element of the enty of the columns represents the property of its CSS style—“class”.
    # e.g., columns = [ ["rank", ".product-rank"], ["name", ".product-name"] ]
    def dashboard_products_diff(expected_table, columns)
        actual_table = []
        (1..5).each do |i|
            sub = "product-item-#{i}"
            selected_css = '//p[@data-mark="' + sub + '"]'
            node = page.find(:xpath, selected_css)
            entry = columns.each_with_object({}) do |arr, hash|
                hash[arr[0]] = node.find(arr[1]).text
            end
            actual_table.concat [entry]
        end
        expected_table.diff!(actual_table)
    end

    def dashboard_categories_diff(expected_table, columns)
        actual_table = []
        (1..2).each do |i|
            sub = "category-item-#{i}"
            selected_css = '//li[@data-mark="' + sub + '"]'
            node = page.find(:xpath, selected_css)
            entry = columns.each_with_object({}) do |arr, hash|
                hash[arr[0]] = node.find(arr[1]).text
            end
            actual_table.concat [entry]
        end
        expected_table.diff!(actual_table)
    end
end

World(Dashboard)
