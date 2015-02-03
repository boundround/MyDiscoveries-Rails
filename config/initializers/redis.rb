uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/")
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
ENV["REDIS_URL"] = ENV["REDISTOGO_URL"]

Soulmate.redis = REDIS
