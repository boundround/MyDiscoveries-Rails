require 'instagram'
Instagram.configure do |config|
  config.client_id = ENV["INSTAGRAM_ID"]
  config.access_token = ENV["INSTAGRAM_SECRET"]
end

# response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
#   session[:access_token] = response.access_token
