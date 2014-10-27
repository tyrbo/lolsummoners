class RateLimit
  attr_reader :ip, :key

  def initialize(request)
    @ip = request.remote_ip
    @key = "#{ip}_#{Time.now.to_i}"
  end

  def limited?
    return false unless @ip
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
