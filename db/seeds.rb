REGIONS = %w(na euw eune)
DIVISIONS = %w(I II III IV V)

def random_boolean
  rand(2) == 1
end

def truncate_database!
  ActiveRecord::Base.connection.tables.reject { |x| x == "schema_migrations" }.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE #{table} RESTART IDENTITY CASCADE")
  end

  Redis.current.flushall
end

truncate_database!

1000.times do |x|
  summoner = Summoner.create(
    summoner_id: x,
    name: "Summoner #{x}",
    summoner_level: 30,
    region: REGIONS.sample
  )

  summoner.league_entry = LeagueEntry.create(
    division: DIVISIONS.sample,
    is_fresh_blood: random_boolean,
    is_hot_streak: random_boolean,
    is_inactive: random_boolean,
    is_veteran: random_boolean,
    league_points: 1000 - x,
    losses: x,
    mini_series: "",
    player_or_team_id: x,
    player_or_team_name: "Summoner #{x}",
    wins: x
  )

  summoner.update_ranking!
end
