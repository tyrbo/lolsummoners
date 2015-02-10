class RateLimit
  attr_reader :key

  def initialize(key)
    @key = key
  end

  def limited?
    redis.exists(key)
  end

  def limit!(timeout = 1, value = nil)
    redis.multi do
      redis.set(key, value)
      redis.expire(key, timeout)
    end
  end

  private

  def redis
    Redis.current
  end
end
