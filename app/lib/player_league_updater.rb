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

  private

  def self.perform_with_error_handling(player)
    begin
      yield
    rescue RiotApi::NotFoundCode
      player.player_league.destroy if player.player_league
      return
    rescue
      return
    end
  end
end
