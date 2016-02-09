every :day do
  rake 'places:publish', environment: environment
  if ENV['BOUNDROUND_ENV'] == 'boundround_production'
    rake 'sitemap:refresh'
  end
end

every :monday, :at => '12pm' do
  rake 'weekly_ucg:send_ucg_update', environment: environment
end
