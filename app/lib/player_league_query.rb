class PlayerLeagueQuery
  attr_reader :api, :summoner_ids

  def initialize(region, players)
    @api = RiotApi.new(region)
    @summoner_ids = Array(players).map(&:summoner_id)
  end

  def execute
    result = api.league_for_full(summoner_ids).map { |_, v| v }.flatten
    result.select { |x| x["queue"] == "RANKED_SOLO_5x5" }
  end
end
