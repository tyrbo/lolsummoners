class Ladder
  PER_PAGE = 25.0

  def initialize(region)
    @region = region
  end

  def find_by_page(page)
    redis_ids = find_redis_ranks(@region, page)
    players = Player.find_players_by_region(redis_ids)
    combine_players_with_rank(players)
  end

  def combine_players_with_rank(players)
    players.map! do |player|
      player.rank = redis.zrevrank("rank_#{player.region}",
                                   "#{player.summoner_id}_#{player.region}")
      player
    end
    players.sort_by { |hash| hash.rank }
  end

  def find_redis_ranks(region, page)
    redis.zrevrange("rank_#{region}", (page - 1) * 25, (page * 25) - 1)
  end

  def self.has_next_page?(opts)
    get_total_players(opts[:id])
    opts[:page].to_i < (@count / PER_PAGE)
  end

  def self.has_prev_page?(opts)
    opts[:page].to_i > 1
  end

  def self.get_total_players(id)
    @count ||= Redis.current.zcard("rank_#{id}")
  end

  private

  def redis
    Redis.current
  end
end
