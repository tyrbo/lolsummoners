class Updater
  def initialize(region)
    @player_updater = PlayerUpdater.new(region)
    #@league_updater = LeagueUpdater.new(region)
  end

  def by_id(ids, league)
    players = @player_updater.by_id(ids)
  end

  def by_name(names, league)
    players = @player_updater.by_name(names)
  end
end
