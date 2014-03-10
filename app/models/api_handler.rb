class ApiHandler
  PLAYER_MAPPINGS = { 'id' => 'summoner_id' }

  def initialize(region)
    @region = region
    @api = api_for(region)
  end

  def player_search(name)
    if !cooldown?(@region, name)
      player = @api.by_name(name)
      unless player.nil?
        player = create_or_update_player(player)
        league = @api.league_for(player.summoner_id)
        create_or_update_player_league(player, league) unless league.nil?
      end
      return true
    else
      false
    end
  end

  def api_for(region)
    if Region.api?(region)
      return RiotApi.new(region)
    else
      return NodeApi.new(region)
    end
  end

  private

  def cooldown?(region, name)
    key_name = "#{region}_#{name}"
    if redis.get(key_name)
      return true
    else
      redis.multi do
        redis.set(key_name, 1)
        redis.expire(key_name, 60*30)
      end
      return false
    end
  end

  def create_or_update_player(attributes)
    player = Player.find_or_initialize_by(summoner_id: attributes['id'], region: @region)
    attributes = remap_hash(attributes, PLAYER_MAPPINGS)
    player.update_attributes(attributes)
    player.save
    player
  end

  def create_or_update_player_league(player, attributes)
    attributes = remap_hash(attributes)
    league_id = create_league(attributes['league_name'], attributes['tier'], attributes['queue'])
    attributes['mini_series'] = stringify_mini_series(attributes['mini_series'])
    attributes['league_id'] = league_id
    attributes.delete('league_name')
    if player.player_league.nil?
      player.create_player_league(attributes)
    else
      player.player_league.update_attributes(attributes)
    end
    modified_points = points_for_ranking(attributes)
    redis.zadd("rank_#{@region}", modified_points, "#{player.summoner_id}_#{@region}")
    redis.zadd("rank_all", modified_points, "#{player.summoner_id}_#{@region}")
  end

  def remap_hash(attributes, mappings = {})
    Hash[attributes.map {|k, v| [mappings[k] || k.underscore, v]}]
  end

  def create_league(name, tier, queue)
    league = League.find_or_initialize_by(name: name, tier: tier, queue: queue, region: @region)
    league.save
    league.id
  end

  def points_for_ranking(attributes)
    points = attributes['league_points']
    points + add_points_for_tier(attributes['tier']) + add_points_for_rank(attributes['rank'])
  end

  def add_points_for_tier(tier)
    case tier
    when 'SILVER'
      5000
    when 'GOLD'
      10000
    when 'PLATINUM'
      15000
    when 'DIAMOND'
      20000
    when 'CHALLENGER'
      25000
    end
  end

  def add_points_for_rank(rank)
    case rank
    when 'I'
      4000
    when 'II'
      3000
    when 'III'
      2000
    when 'IV'
      1000
    end
  end

  def stringify_mini_series(series)
    unless series.nil?
      "#{series['target']},#{series['wins']},#{series['losses']},#{series['timeLeftToPlayMillis']}"
    else
      nil
    end
  end

  def redis
    Redis.current
  end
end
