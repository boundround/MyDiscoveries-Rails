every :day do
  rake 'places:publish', environment: environment
  if ENV['BOUNDROUND_ENV'] == 'boundround_production' 
    rake 'sitemap:refresh'
  end
end
