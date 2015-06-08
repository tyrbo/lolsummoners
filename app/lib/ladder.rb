class Ladder
  PER_PAGE = 25.0

  def self.rank_for(region, player)
    redis.zrevrank("rank_#{region}", "#{player.summoner_id}_#{player.region}") + 1
  end

  def self.get_total_players(id)
    redis.zcard("rank_#{id}")
  end

  def self.next_page?(opts)
    opts[:page].to_i < (get_total_players(opts[:region]) / PER_PAGE)
  end

  def self.prev_page?(opts)
    opts[:page].to_i > 1
  end

  def self.redis
    Redis.current
  end

  def initialize(region)
    @region = region
  end

  def find_by_page(page)
    redis_ids = find_redis_ranks(page)
    players = Player.includes(player_league: :leage).find_players_by_region(redis_ids)

    # Temporary fix
    temp = players.select { |x| !x.player_league }
    if temp
      temp.each do |x|
        Redis.current.zrem("rank_#{x.region}", "#{x.summoner_id}_#{x.region}")
        Redis.current.zrem("rank_all", "#{x.summoner_id}_#{x.region}")
      end

      redis_ids = find_redis_ranks(page)
      players = Player.includes(player_league: :league).find_players_by_region(redis_ids)
    end

    combine_players_with_rank(players)
  end

  def combine_players_with_rank(players)
    players.each do |player|
      player.rank = redis.zrevrank("rank_#{@region}", "#{player.summoner_id}_#{player.region}") + 1
    end.sort_by { |player| player.rank }
  end

  def find_redis_ranks(page)
    redis.zrevrange("rank_#{@region}", (page - 1) * 25, (page * 25) - 1)
  end

  private

  def redis
    Redis.current
  end
end
