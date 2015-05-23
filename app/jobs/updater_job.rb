class UpdaterJob < ActiveJob::Base
  def perform(ids)
    players = Player.eager_load(:player_league).find(ids).reject(&:limited?)
    players.each(&:limit!)

    players.group_by(&:region).each do |region, batch|
      begin
        PlayerLeagueUpdater.update_all(region, batch)
      rescue RiotApi::InvalidStatusCode
        Rails.logger.warn("Received invalid status code on #{region} with #{batch.map(&:summoner_id).inspect}")
        next
      end
    end
  end
end
