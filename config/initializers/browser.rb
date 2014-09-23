Rails.configuration.middleware.use Browser::Middleware do
  if request.path == '/'
    redirect_to map_path unless browser.modern? && !browser.mobile?
    if browser.ipad? && browser.version.to_i < 5 || browser.ios4? || broswer.ios5?
      redirect_to map_path
    end
  end
end
