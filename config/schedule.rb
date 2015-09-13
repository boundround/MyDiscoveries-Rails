every :day do
  rake 'places:publish', environment: environment
  rake 'sitemap:refresh'
end
