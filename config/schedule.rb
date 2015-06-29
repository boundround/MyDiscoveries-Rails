every 1.minute do
  rake 'posts:publish', environment: environment
end
