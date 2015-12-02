REGIONS = %w(na euw eune)
DIVISIONS = %w(I II III IV V)
TIERS = %w(CHALLENGER MASTER DIAMOND PLATINUM GOLD SILVER BRONZE)

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

20.times.map do |x|
  League.create(name: "League #{x}", queue: "RANKED_SOLO_5x5", tier: TIERS.sample)
end

summoners = 5000.times.map do |x|
  Summoner.new(
    summoner_id: x,
    name: "Summoner #{x}",
    summoner_level: 30,
    region: REGIONS.sample
  )
end

ActiveRecord::Base.transaction do
  summoners.each(&:save)
end

league_entries = 5000.times.map do |x|
  LeagueEntry.new(
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
    wins: x,
    league: League.order("RANDOM()").first,
    summoner_id: x + 1
  )
end

ActiveRecord::Base.transaction do
  league_entries.each(&:save)
end

Summoner.all.each(&:update_ranking!)
