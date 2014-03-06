Post.destroy_all

Post.create(title: 'Test Post', body: 'This is some content with the post.<br><br>Does HTML work?')
Post.create(title: 'Test Post', body: 'This is some content with the post.<br><br>Does HTML work?')
Post.create(title: 'Test Post', body: 'This is some content with the post.<br><br>Does HTML work?')

Player.destroy_all
Redis.current.flushall

50000.times do |n|
  player = Player.new(summoner_id: n, name: "A#{n}", profile_icon_id: 1, summoner_level: 30, region: 'na')
  player.build_player_league(league_points: n, tier: 'CHALLENGER', wins: n)
  player.save
  Redis.current.zadd('rank_na', n, "#{n}_na")
  Redis.current.zadd('rank_all', n, "#{n}_na")
end

50000.times do |n|
  player = Player.new(summoner_id: n, name: "B#{n}", profile_icon_id: 1, summoner_level: 30, region: 'euw')
  player.build_player_league(league_points: n, tier: 'CHALLENGER', wins: n)
  player.save
  Redis.current.zadd('rank_euw', n, "#{n}_euw")
  Redis.current.zadd('rank_all', n, "#{n}_euw")
end
