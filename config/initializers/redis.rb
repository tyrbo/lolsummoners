host = ENV['REDIS_HOST'] || '127.0.0.1'
Redis.current = Redis.new(host: host)
