class UpdaterJob < ActiveJob::Base
  def perform
    loop do
      players = Player.find_players_to_update(1.day.ago).group_by(&:region)
      break if players.length.zero?

      players.each do |region, batch|
        PlayerLeagueUpdater.update_all(region, batch)
      end

      nil
    end
  end
end
