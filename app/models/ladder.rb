class Ladder
  PER_PAGE = 25.0

  def self.rank_for(region, player)
    Redis.current.zrevrank("rank_#{region}", "#{player.summoner_id}_#{player.region}") + 1
  end

  def self.get_total_players(id)
    Redis.current.zcard("rank_#{id}")
  end

  def self.next_page?(opts)
    opts[:page].to_i < (get_total_players(opts[:region]) / PER_PAGE)
  end

  def self.prev_page?(opts)
    opts[:page].to_i > 1
  end

  def initialize(region)
    @region = region
  end

  def find_by_page(page)
    redis_ids = find_redis_ranks(page)
    players = Player.includes(:player_league).find_players_by_region(redis_ids)
    combine_players_with_rank(players)
  end

  def combine_players_with_rank(players)
    players.each do |player|
      player.ladder = redis.zrevrank("rank_#{@region}", "#{player.summoner_id}_#{player.region}")
    end.sort_by { |player| player.ladder }
  end

  def find_redis_ranks(page)
    redis.zrevrange("rank_#{@region}", (page - 1) * 25, (page * 25) - 1)
  end

  private

  def redis
    Redis.current
  end
end
