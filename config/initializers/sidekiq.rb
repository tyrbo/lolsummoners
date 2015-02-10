if Rails.env.development?
  redis = ENV['REDIS_URL']

  Sidekiq.configure_server do |config|
    config.redis = { url: redis }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis }
  end
end
