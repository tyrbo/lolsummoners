class SearchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def self.queue(opts)
    self.perform_async(opts)
    true
  end

  def perform(opts)
    #ApiHandler.new(opts['region']).player_search(opts)
    updater = Updater.new(opts['region'])
    key_name = key_name_for(opts)

    data = []
    if opts['by'] == 'name'
      data = updater.by_name([opts['id']])
    end

    if player = data.find { |x| x.internal_name == opts['id'] }
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
