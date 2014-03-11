class PubSub
  def self.publish(key, value)
    redis.publish(key, value)
  end

  def self.redis
    Redis.current
  end
end
