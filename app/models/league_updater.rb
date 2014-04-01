class LeagueUpdater
  def update_loop
    loop do
      player = find_player_to_update
      if player
        update_players(player)
      else
        sleep(300)
      end
    end
  end

  def update_players(player)
    response, code = get_league(player)
    region = player.region
    if code == 200
      league = LeagueBuilder.create_or_update(response['name'], response['tier'], response['queue'], region)
      handle_response(response['entries'], league, region)
    else
      player.touch
    end
  end

  def find_player_to_update
    PlayerLeague.player_to_update
  end

  private

  def get_league(player)
    api = RiotApi.new(player.region)
    api.league_for_full(player.player_or_team_id)
  end

  def handle_response(response, league, region)
    i = 0
    response.each do |attr|
      i++
      process(attr, league, region)
    end
    puts "Updated: #{i}"
  end

  def process(attr, league, region)
    hash = { 'id' => attr['playerOrTeamId'], 'name' => attr['playerOrTeamName'], 'summonerLevel' => 30 }
    player = PlayerBuilder.create_or_update(hash, region)
    PlayerLeagueBuilder.create_or_update(player, attr, region, league)
  end
end
