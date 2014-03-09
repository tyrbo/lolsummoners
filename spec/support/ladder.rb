include ApplicationHelper

def build_ladder_player(opts)
  @region = opts[:region]
  @summoner_id = opts[:summoner_id] || randomize_value
  @points = opts[:points] || randomize_value
  @name = opts[:name] || "A#{Random.new.rand(1...1000000)}"
  create_new_player
  create_ranking
end

def randomize_value
  r = Random.new
  r.rand(1...10000000)
end

def create_new_player
  player = build(:player, summoner_id: @summoner_id, region: @region, name: @name)
  player.build_player_league(tier: 'Test', league_points: @points)
  player.save
end

def create_ranking
  Redis.current.pipelined do
    Redis.current.zadd("rank_#{@region}", @points, "#{@summoner_id}_#{@region}")
    Redis.current.zadd("rank_all", @points, "#{@summoner_id}_#{@region}")
  end
end
