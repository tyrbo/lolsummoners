class ApiHandler
  def initialize(region)
    @region = region
    @api = api_for(region)
  end

  def player_search(name)
    key_name = "#{@region}_#{name}"
    message = 'fail'
    RateLimit.set("limited_#{key_name}", 60 * 30)
    player_data = @api.by_name(name)
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

  def push(key_name, message)
    PubSub.publish(key_name, message)
    RateLimit.set("limited_#{key_name}", 60 * 30, message)
  end

  def api_for(region)
    if Region.api?(region)
      return RiotApi.new(region)
    else
      return NodeApi.new(region)
    end
  end
end
