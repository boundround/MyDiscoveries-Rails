namespace :api do
	desc "API Routes"
	task routes: :environment do
		API::Base.routes.each do |api|
			method = api.route_method.ljust(10) if api.route_method
			path = api.route_path.gsub ":version", api.route_version if api.route_version
			puts "		#{method} #{path}"
		end
	end
end