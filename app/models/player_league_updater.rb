class PlayerLeagueUpdater
  attr_reader :region, :api

  def initialize(region)
    @api = RiotApi.new(region)
    @region = region
  end

  def by_player(players)
    response = players.each_slice(40).map do |batch|
      api.league_for_full(batch.map(&:summoner_id))
    end
    handle(response)
  end

  def handle(response)
    response.each do |batch|
      batch.each do |data|
        if data = data.last.detect { |league| league['queue'] == 'RANKED_SOLO_5x5' }
          update(data)
        end
      end
    end
  end

  def update(data)
    league = LeagueBuilder.create_or_update(data['name'], data['tier'], data['queue'], region)
    players = PlayerUpdater.new(region).by_id(players_to_update(data))

    data['entries'].each do |entry|
      player = players.detect { |x| x.summoner_id == entry['playerOrTeamId'].to_i }
      if player
        PlayerLeagueBuilder.create_or_update(player, entry, region, league)
      end
    end
  end

  private

  def players_to_update(data)
    data['entries'].map { |x| x['playerOrTeamId'] }
  end
end