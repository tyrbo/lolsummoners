class RateLimit
  def self.limited?(key_name)
    redis.exists(key_name)
  end

  def self.get(key_name)
    redis.get(key_name)
  end

  def self.set(key_name, timeout, value = nil)
    redis.multi do
      redis.set(key_name, value)
      redis.expire(key_name, timeout)
    end
  end

  def self.redis
    Redis.current
  end
end
