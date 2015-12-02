class Api::LeagueEntry
  attr_reader :region
  attr_accessor :league_id

  def initialize(args, region)
    @args = args
    @region = region
  end

  def division
    @args.fetch("division")
  end

  def is_fresh_blood
    @args.fetch("isFreshBlood")
  end

  def is_hot_streak
    @args.fetch("isHotStreak")
  end

  def is_inactive
    @args.fetch("isInactive")
  end

  def is_veteran
    @args.fetch("isVeteran")
  end

  def league_points
    @args.fetch("leaguePoints")
  end

  def losses
    @args.fetch("losses")
  end

  def mini_series
    @args.fetch("miniSeries", {})
  end

  def player_or_team_id
    @args.fetch("playerOrTeamId")
  end

  def player_or_team_name
    @args.fetch("playerOrTeamName")
  end

  def wins
    @args.fetch("wins")
  end

  def to_ar
    raise "Missing league id" unless league_id

    ::Summoner.find_or_create_by(summoner_id: player_or_team_id, region: region).tap do |x|
      x.update(name: player_or_team_name, summoner_level: 30)

      x.create_league_entry(
        division: division,
        is_fresh_blood: is_fresh_blood,
        is_hot_streak: is_hot_streak,
        is_inactive: is_inactive,
        is_veteran: is_veteran,
        league_id: league_id,
        league_points: league_points,
        losses: losses,
        mini_series: mini_series,
        player_or_team_id: player_or_team_id,
        player_or_team_name: player_or_team_name,
        wins: wins
      )
    end
  end
end
