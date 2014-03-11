class SearchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def self.queue(opts)
    key_name = "limited_#{opts[:region]}_#{opts[:id]}"
    unless RateLimit.limited?(key_name)
      self.perform_async(opts)
      return true
    end
    false
  end

  def perform(opts)
    ApiHandler.new(opts['region']).player_search(opts)
  end
end
