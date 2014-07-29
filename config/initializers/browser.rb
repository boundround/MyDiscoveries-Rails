Rails.configuration.middleware.use Browser::Middleware do
  if request.path == '/'
    redirect_to '/map' unless browser.modern?
    redirect_to '/map' if browser.android? && browser.version.to_i < 4
  end
end
