include ApplicationHelper

def build_ladder_player(opts)
  @region = opts[:region]
  @summoner_id, @points = randomize_player_values
  create_new_player
  create_ranking
end

def randomize_player_values
  r = Random.new
  [r.rand(1...1000000), r.rand(1...1000)]
end

def create_new_player
  player = build(:player, summoner_id: @summoner_id, region: @region)
  player.build_player_league(tier: 'Test', league_points: @points)
  player.save
end

def create_ranking
  Redis.current.pipelined do
    Redis.current.zadd("rank_#{@region}", @points, "#{@summoner_id}_#{@region}")
    Redis.current.zadd("rank_all", @points, "#{@summoner_id}_#{@region}")
  end
end
