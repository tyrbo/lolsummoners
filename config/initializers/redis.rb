host = ENV['REDIS_HOST']

if host
  Redis.current = Redis.new(host: host)
else
  Redis.current = Redis.new(url: ENV['REDIS_URL'])
end
