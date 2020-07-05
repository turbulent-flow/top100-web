module ApplicationHelper
    def customize_image_tag(name)
        if ENV["RACK_ENV"] == "development"
            image_tag("#{ENV["CLOUDFRONT_ENDPOINT"]}/#{name}")
        else
            image_tag(name)
        end
    end
end
