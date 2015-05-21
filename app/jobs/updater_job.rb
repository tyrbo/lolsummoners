class UpdaterJob < ActiveJob::Base
  def perform(players)
    #players = Player.find_players_to_update(1.day.ago).group_by(&:region)
    #break if players.length.zero?

    players.each do |region, batch|
      begin
        PlayerLeagueUpdater.update_all(region, batch)
      rescue RiotApi::InvalidStatusCode
        Rails.logger.warn("Received invalid status code on #{region} with #{batch.map(&:summoner_id).inspect}")
        next
      end
    end
  end
end
