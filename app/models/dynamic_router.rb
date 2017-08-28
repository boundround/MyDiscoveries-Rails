class DynamicRouter
	class << self
	  def load
	  	if ActiveRecord::Base.connection.table_exists? :landings
		    BoundRoundWeb::Application.routes.draw do
		      Landing.all.each do |landing|
		      	puts "Routing #{landing.from_url}"
		      	get "/#{landing.from_url}" => redirect("#{landing.to_url}")
		      end
		    end
		  end
	  end
	  
	  def reload
	    BoundRoundWeb::Application.routes_reloader.reload!
	  end
	end
end
