class Ladder
  PER_PAGE = 25

  def initialize(region)
    @region = region
  end

  def find_by_page(page)
    redis_ids = find_players_by_rank(page)
    players = Player.find_by_ranked_ids(redis_ids)
    combine_players_with_rank(players)
  end

  def find_players_by_rank(page)
    if @region == 'all'
      ids = []
      $regions.each do |rgn|
        ids << find_redis_ranks(rgn, page)
      end
      ids.flatten
    else
      find_redis_ranks(@region, page)
    end
  end

  def combine_players_with_rank(players)
    players.map! do |player|
      player.rank = redis.zrevrank("rank_#{player.region}", "#{player.summoner_id}_#{player.region}")
      player
    end
    players.sort_by { |hash| hash.rank }
  end

  def find_redis_ranks(region, page)
    page = 1 if page.nil?
    redis.zrevrange("rank_#{region}", (page - 1) * 25, (page * 25) - 1)
  end

  private

  def redis
    Redis.current
  end
end
