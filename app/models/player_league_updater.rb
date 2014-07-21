class PlayerLeagueUpdater
  attr_reader :region, :api

  def initialize(region)
    @api = RiotApi.new(region)
    @region = region
  end

  def by_player(players)
    response = []
    players.each_slice(40) do |batch|
      response << api.league_for_full(batch.map(&:summoner_id))
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
    league_obj = LeagueBuilder.create_or_update(data['name'], data['tier'], data['queue'], region)
    player_ids = Player.where(summoner_id: data['entries'].map { |x| x['playerOrTeamId'] })
                       .map(&:summoner_id)
    to_create = data['entries'].reject { |e| player_ids.any? { |x| x == e['playerOrTeamId'] } }
                               .map { |e| e['playerOrTeamId'] }

    to_update = player_ids.concat(to_create)

    players = PlayerUpdater.new(region)
                           .by_id(to_update)

    data['entries'].each do |entry|
      player = players.detect { |x| x.summoner_id == entry['playerOrTeamId'].to_i }
      if player
        PlayerLeagueBuilder.create_or_update(player, entry, region, league_obj)
      end
    end
  end
end
