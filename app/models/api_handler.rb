class ApiHandler
  def initialize(region)
    @region = region
    @api = api_for(region)
  end

  def player_search(name)
    if !cooldown?(@region, name)
      player = @api.by_name(name)
      create_or_update_player(player) unless player.nil?
      return true
    else
      return false
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
    player.tap do |p|
      p.summoner_id = attributes['id']
      p.name = attributes['name']
      p.profile_icon_id = attributes['profileIconId']
      p.summoner_level = attributes['summonerLevel']
      p.revision_date = attributes['revisionDate']
      p.region = @region
    end
    player.save
  end

  def redis
    Redis.current
  end
end
