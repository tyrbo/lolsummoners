class SearchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def self.queue(region, name)
    key_name = "limited_#{region}_#{name}"
    unless RateLimit.limited?(key_name)
      self.perform_async(region, name)
    end
  end

  def perform(region, name)
    ApiHandler.new(region).player_search(name)
  end
end
