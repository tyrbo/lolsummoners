class PlayerLeagueUpdater
  def self.update(player)
    perform_with_error_handling(player) do
      api = RiotApi.new(player.region)
      result = api.league_for_full([player.summoner_id])
      summoner_id = player.summoner_id.to_s

      if data = result[summoner_id].detect { |x| x["queue"] == "RANKED_SOLO_5x5" }
        league = LeagueBuilder.create_or_find(data, player.region)
        PlayerLeagueBuilder.create_or_update(player, data["entries"].detect { |x| x["playerOrTeamId"] == summoner_id }, player.region, league)
      end
    end
  end

  def self.update_all(region, players)
    perform_with_error_handling(players, region) do
      api = RiotApi.new(region)
      ids = players.map(&:summoner_id)

      ids.each_slice(10) do |batch|
        result = api.league_for_full(batch).map { |_, v| v }.flatten

        result.select { |x| x["queue"] == "RANKED_SOLO_5x5" }.each do |data|
          league = LeagueBuilder.create_or_find(data, region)

          data["entries"].each do |entry|
            player = players.detect { |x| x.summoner_id == entry["playerOrTeamId"].to_i } || PlayerBuilder.create_from_league(entry, region)
            players << player
            PlayerLeagueBuilder.create_or_update(player, entry, region, league)
          end
        end
      end

      leagues = players.uniq.map(&:player_league).map(&:id)
      PlayerLeague.where(id: leagues).update_all(updated_at: Time.now)
    end
  end

  private

  def self.perform_with_error_handling(player, region = nil)
    begin
      yield
    rescue RiotApi::NotFoundCode
      player.player_league.destroy if player.player_league
      return
    end
  end
end
