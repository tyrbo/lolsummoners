class Seeder
  def self.handle(file)
    File.open(file, 'r') do |f|
      i = 0
      while line = f.gets
        process(line)
      end
    end
  end

  def self.process(line)
    obj = JSON.parse(line)
    return if obj['inactive'] == 1

    player_attributes = attributes_for_player(obj)
    player = PlayerBuilder.create(player_attributes, obj['region'].downcase)

    player_league = attributes_for_player_league(obj)
    PlayerLeagueBuilder.create(player, player_league, obj['region'].downcase)
  end

  private

  def self.attributes_for_player(obj)
    {
      'name' => obj['name'],
      'summoner_id' => obj['summoner_id'],
      'summoner_level' => 30
    }
  end

  def self.attributes_for_player_league(obj)
    {
      'is_fresh_blood' => obj['freshBlood'],
      'is_hot_streak' => obj['hotStreak'],
      'is_inactive' => obj['inactive'],
      'is_veteran' => obj['veteran'],
      'leagueName' => obj['league']['name'],
      'league_points' => obj['points'] % 1000,
      'mini_series' => series_hash(obj['miniSeries']),
      'player_or_team_id' => obj['summoner_id'],
      'player_or_team_name' => obj['name'],
      'queueType' => obj['league']['queue'],
      'rank' => League.rank_from_points(obj['points']),
      'tier' => obj['league']['tier'],
      'wins' => obj['wins']
    }
  end

  def self.series_hash(series)
    unless series.nil?
      split = series.split(',')
      return { 'target' => split[0], 'wins' => split[1], 'losses' => split[2], 'timeLeftToPlayMillis' => split[3] }
    else
      nil
    end
  end
end
