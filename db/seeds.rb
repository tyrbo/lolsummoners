Post.destroy_all

Post.create(title: 'Test Post', body: 'This is some content with the post.<br><br>Does HTML work?')
Post.create(title: 'Test Post', body: 'This is some content with the post.<br><br>Does HTML work?')
Post.create(title: 'Test Post', body: 'This is some content with the post.<br><br>Does HTML work?')

Player.destroy_all

player = Player.new(summoner_id: 1, name: 'Peak', profile_icon_id: 1, summoner_level: 30, region: 'na')
player.build_player_league(league_points: 95, tier: 'CHALLENGER', wins: 144)
player.save

Redis.current.flushall
Redis.current.zadd('rank_na', 1000, 1)
