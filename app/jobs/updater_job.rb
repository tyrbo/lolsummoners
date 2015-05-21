class UpdaterJob < ActiveJob::Base
  def perform(ids)
    #players = Player.find_players_to_update(1.day.ago).group_by(&:region)
    #break if players.length.zero?

    ids.each do |region, batch|
      begin
        players = Player.eager_load(:player_league).find(batch)
        PlayerLeagueUpdater.update_all(region, players)
      rescue RiotApi::InvalidStatusCode
        Rails.logger.warn("Received invalid status code on #{region} with #{batch.map(&:summoner_id).inspect}")
        next
      end
    end
  end
end
