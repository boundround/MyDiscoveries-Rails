Rails.configuration.middleware.use Browser::Middleware do
  if request.path == '/'
    redirect_to map_path unless browser.modern? && !browser.mobile?
  end
end
