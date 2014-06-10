class LeagueUpdater
  def update_loop
    time = 4.hours.ago
    puts "Updated before #{time}"
    loop do
      player = find_player_to_update(time)
      if player
        puts "Updating with: #{player.id}"
        update_players(player)
        player.touch
      else
        puts "Cooldown! No one to update yet..."
        time = 4.hours.ago
        sleep(30)
      end
    end
  end

  def update_players(player)
    responses = get_league(player)
    region = player.region
    responses.each do |response|
      response.each do |player|
        puts player
        #data = response.last.detect { |r| r['queue'] == 'RANKED_SOLO_5x5' }
        #if data
        #  ActiveRecord::Base.transaction do
        #    league = LeagueBuilder.create_or_update(data['name'], data['tier'], data['queue'], region)
        #    handle_response(data['entries'], league, region)
        #  end
        #end
      end
    end
  end

  def find_player_to_update(time = 24.hours.ago)
    PlayerLeague.player_to_update(time).first
  end

  private

  def get_league(player)
    api = RiotApi.new(player.region)
    api.league_for([player.player_or_team_id])
  end

  def handle_response(response, league, region)
    i = 0
    summoners = response.collect { |n| n['playerOrTeamId'].to_i }
    existing_summoners = Player.includes(:player_league).where(summoner_id: summoners, region: region)
    response.each do |attr|
      i = i + 1
      process(attr, existing_summoners.detect {|n| n.summoner_id == attr['playerOrTeamId'].to_i}, league, region)
    end
    leagues = existing_summoners.collect { |n| n.player_league.id }
    PlayerLeague.where(id: leagues).update_all(updated_at: Time.now)
    puts "Existing: #{existing_summoners.length}"
    puts "Updated: #{i}"
  end

  def process(attr, player = nil, league, region)
    hash = { 'id' => attr['playerOrTeamId'], 'name' => attr['playerOrTeamName'], 'summonerLevel' => 30 }
    player = PlayerBuilder.create_or_update(hash, region, player)
    PlayerLeagueBuilder.create_or_update(player, attr, region, league)
  end
end
