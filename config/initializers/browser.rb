Rails.configuration.middleware.use Browser::Middleware do
  if request.path == '/'
    redirect_to map_path unless browser.modern?
    redirect_to map_path if browser.android? && browser.version.to_i < 4
  end
end
