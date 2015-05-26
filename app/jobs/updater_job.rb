class UpdaterJob < ActiveJob::Base
  queue_as :updates

  def perform(region, ids)
    increase_count(region)

    players = Player.eager_load(:player_league).where(id: ids)

    process(region, players)

    decrease_count(region)
  end

  def process(region, players)
    players.each_slice(10) do |batch|
      begin
        PlayerLeagueUpdater.new(region, batch).update_all
      rescue RiotApi::InvalidStatusCode
        Rails.logger.warn("Received invalid status code on #{region} with #{batch.map(&:summoner_id).inspect}")
        next
      end
    end
  end

  def increase_count(region)
    Redis.current.incr("queued_#{region}")
  end

  def decrease_count(region)
    Redis.current.decr("queued_#{region}")
  end
end
