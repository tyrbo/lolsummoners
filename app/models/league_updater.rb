class LeagueUpdater
  def update_loop
    loop do
      player = find_player_to_update
      if player
        puts "Updating with: #{player.player_id}"
        update_players(player)
        player.touch
      else
        sleep(300)
      end
    end
  end

  def update_players(player)
    response, code = get_league(player)
    region = player.region
    if code == 200
      ActiveRecord::Base.transaction do
        league = LeagueBuilder.create_or_update(response['name'], response['tier'], response['queue'], region)
        handle_response(response['entries'], league, region)
      end
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
    summoners = response.collect { |n| n['playerOrTeamId'].to_i }
    existing_summoners = Player.includes(:player_league).where(summoner_id: summoners, region: region)
    response.each do |attr|
      i = i + 1
      process(attr, existing_summoners.find {|n| n.summoner_id == attr['playerOrTeamId'].to_i}, league, region)
    end
    leagues = existing_summoners.collect { |n| n.player_league.id }
    PlayerLeague.where(id: leagues).update_all(updated_at: Time.now)
    puts "Updated: #{i}"
  end

  def process(attr, player = nil, league, region)
    hash = { 'id' => attr['playerOrTeamId'], 'name' => attr['playerOrTeamName'], 'summonerLevel' => 30 }
    player = PlayerBuilder.create_or_update(hash, region, player)
    PlayerLeagueBuilder.create_or_update(player, attr, region, league)
  end
end
