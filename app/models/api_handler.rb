class ApiHandler
  def initialize(region)
    @region = region
    @api = api_for(region)
  end

  def player_search(opts)
    key_name = key_name_for(opts)
    player_data, response = @api.by_name(opts['id'])
    message = "fail #{response}"
    RateLimit.set("limited_#{key_name}", 60 * 30) if response == '200' || response == '404'
    unless player_data.nil?
      player = build_player(player_data)
      message = "done #{player.summoner_id}"
    end
    push(key_name, message)
  end

  private

  def build_player(player_data)
      player = PlayerBuilder.create_or_update(player_data, @region)
      league_data = @api.league_for(player.summoner_id)
      PlayerLeagueBuilder.create_or_update(player, league_data, @region) unless league_data.nil?
      player
  end

  def key_name_for(opts)
    "#{@region}_#{opts['id']}"
  end

  def push(key_name, message)
    #PubSub.publish(key_name, message)
    RateLimit.set("response_#{key_name}", 60 * 30, message)
  end

  def api_for(region)
    return RiotApi.new(region)
  end
end
