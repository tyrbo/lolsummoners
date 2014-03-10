class PubSub
  def self.publish(key, value)
    Redis.current.publish(key, value)
  end

  def self.redis
    Redis.current
  end
end
