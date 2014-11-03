class SearchWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def self.queue(opts)
    self.perform_async(opts)
    true
  end

  def perform(opts)
    #ApiHandler.new(opts['region']).player_search(opts)
  end
end
