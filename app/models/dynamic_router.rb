class DynamicRouter

  def self.load
    BoundRoundWeb::Application.routes.draw do
      Landing.all.each do |landing|
      	puts "Routing #{landing.from_url}"
      	get "/#{landing.from_url}" => redirect("#{landing.to_url}")
      end
    end
  end

  def self.reload
    BoundRoundWeb::Application.routes_reloader.reload!
  end

end