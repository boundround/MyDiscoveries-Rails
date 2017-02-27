every :day do
  rake 'places:publish', environment: environment
  if ENV['BOUNDROUND_ENV'] == 'boundround_production'
    rake 'sitemap:refresh'
    rake 'page_ranking_weight:update'
  end
end

every :monday, :at => '12pm' do
  rake 'weekly_ucg:send_ucg_update', environment: environment
end

every 15.minutes do
  rake 'ax:fetch', environment: environment
end
