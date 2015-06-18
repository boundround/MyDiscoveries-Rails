Rails.configuration.middleware.use Browser::Middleware do
  h = request.host()
  if !h.include?("schoolsafari") && !h.include?("crzy") then
    if request.path == '/'
      redirect_to map_path unless browser.modern? && !browser.mobile?
      if browser.ipad? && browser.version.to_i < 5 || browser.ios4? || browser.ios5?
        redirect_to map_path
      end
    end

    if request.path == '/map_only' || request.path == '/map'
      redirect_to root_path unless browser.mobile?
    end
  end
end
