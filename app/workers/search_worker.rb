class SearchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def self.queue(opts)
    key = "limited_#{opts[:region]}_#{opts[:by]}_#{opts[:id]}"

    unless RateLimit.new(key).limited?
      RateLimit.new(key).limit!(60 * 15)

      self.perform_async(opts)

      return true
    end
    false
  end

  def perform(opts)
    updater = Updater.new(opts['region'])
    key_name = key_name_for(opts)

    player = nil
    if opts['by'] == 'name'
      data = updater.by_name([opts['id']])
      player = data.find { |x| x.internal_name == opts['id'] }
    elsif opts['by'] == 'sid'
      data = updater.by_id([opts['id']])
      player = data.find { |x| x.summoner_id == opts['id'] }
    end

    if player
      push("response_#{key_name}", 60 * 30, "done #{player.summoner_id}")
    else
      push("response_#{key_name}", 60 * 30, "fail 404")
    end
  end

  private

  def key_name_for(opts)
    @key_name ||= "#{opts['region']}_#{opts['by']}_#{opts['id']}"
  end

  def push(key, timeout, message)
    Redis.current.multi do
      Redis.current.set(key, message)
      Redis.current.expire(key, timeout)
    end
  end
end
