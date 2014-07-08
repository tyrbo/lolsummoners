class ApiHandler
  def initialize(region)
    @region = region
    @api = api_for(region)
  end

  def player_search(opts)
    key_name = key_name_for(opts)
    player_data, response = nil, nil
    if opts['by'] == 'name'
      player_data, response = @api.by_name(opts['id'])
    elsif opts['by'] == 'sid'
      player_data, response = @api.by_summoner_id(opts['id'])
    end
    message = "fail #{response}"
    RateLimit.set("limited_#{key_name}", 30.minutes) if response == 200 || response == 404
    unless player_data.nil?
      player = build_player(player_data)
      message = "done #{player.summoner_id}"
    end
    push(key_name, message, opts['caller'])
  end

  private

  def build_player(player_data)
    player = PlayerBuilder.create_or_update(player_data, @region)
    league_data, _ = @api.league_for(player.summoner_id)
    if league_data
      league = LeagueBuilder.create_or_update(league_data['name'], league_data['tier'], league_data['queue'], @region)
      player_league = PlayerLeagueBuilder.create_or_update(player, league_data.fetch('entries').first, @region, league)
    end
    player
  end

  def key_name_for(opts)
    "#{@region}_#{opts['by']}_#{opts['id']}"
  end

  def push(key_name, message, call)
    RateLimit.set("response_#{key_name}", 60 * 30, "#{message} #{call}")
  end

  def api_for(region)
    RiotApi.new(region)
  end
end
