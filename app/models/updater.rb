class Updater
  attr_reader :player_updater, :league_updater

  def initialize(region)
    @player_updater = PlayerUpdater.new(region)
    @league_updater = PlayerLeagueUpdater.new(region)
  end

  def by_id(ids, league = true)
    players = player_updater.by_id(ids)
    if league
      league_updater.by_player(players)
    end

    players
  end

  def by_name(names, league = true)
    players = player_updater.by_name(names)
    if league
      league_updater.by_player(players)
    end

    players
  end
end
