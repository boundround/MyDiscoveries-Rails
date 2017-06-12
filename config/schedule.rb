every 15.minutes do
  rake 'ax:fetch', environment: environment
end

every 1.day do
  rake 'db:dump', environment: environment
end
