class PlayerLeagueUpdater
  def self.update(player)
    results = PlayerLeagueQuery.new(player.region, player).execute
    summoner_id = player.summoner_id.to_s

    if data = results.detect { |x| x["participantId"] == summoner_id }
      league = LeagueBuilder.create_or_find(data, player.region)
      PlayerLeagueBuilder.create_or_update(player, data["entries"].detect { |x| x["playerOrTeamId"] == summoner_id }, player.region, league)
    else
      player.player_league.destroy if player.player_league
    end
  end

  attr_reader :region, :players, :updated

  def initialize(region, players)
    @region = region
    @players = players
    @updated = []
  end

  def update_all
    results = PlayerLeagueQuery.new(region, players).execute
    players = players.concat(Player.eager_load(:player_league).where(summoner_id: results.map { |y| y["entries"].map { |x| x["playerOrTeamId"].to_i } }, region: region)).uniq

    results.each do |data|
      player_leagues = process_entries(data)
      PlayerLeague.where(id: player_leagues.map(&:id)).update_all(updated_at: Time.now)
    end

    prune_missing_players
  end

  def process_entries(data)
    league = LeagueBuilder.create_or_find(data, region)

    data["entries"].map do |entry|
      player = players.detect { |x| x.summoner_id == entry["playerOrTeamId"].to_i } || PlayerBuilder.create_from_league(entry, region)
      updated << player
      PlayerLeagueBuilder.create_or_update(player, entry, region, league)
    end
  end

  def prune_missing_players
    missing = (players - updated)
    PlayerLeague.destroy_all(id: missing.map(&:id))
  end
end
