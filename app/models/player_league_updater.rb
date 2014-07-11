class PlayerLeagueUpdater
  def initialize(region)
    @api = RiotApi.new(region)
    @region = region
  end

  def by_player(players)
    response = []
    players.each_slice(50) do |batch|
      ids = batch.map(&:summoner_id)
      response << @api.league_for(ids)
    end
    handle(response)
  end

  def handle(response)
    result = {}
    response.each do |batch|
      batch.each do |player|
        update(player.last)
        #result.store(player.first, PlayerBuilder.create_or_update(player.last, @region, nil))
      end
    end
    result
  end

  def update(player)
    league = player.detect { |league| league['queue'] == 'RANKED_SOLO_5x5' }
    if !league.nil?
      p league
    end
  end
end
