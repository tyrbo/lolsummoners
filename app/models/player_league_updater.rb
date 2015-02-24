class PlayerLeagueUpdater
  attr_reader :region, :api, :players, :summoner_ids

  def initialize(region)
    @api = RiotApi.new(region)
    @region = region
    @summoner_ids = []
  end

  def by_player(players)
    @players = players

    response = players.each_slice(10).map do |batch|
      summoner_ids.concat(batch.map(&:summoner_id))
      api.league_for_full(summoner_ids)
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

    Player.where(summoner_id: summoner_ids).each { |p| p.player_league && p.player_league.destroy }
  end

  def update(data)
    league = LeagueBuilder.create_or_update(data['name'], data['tier'], data['queue'], region)
    new_players = PlayerUpdater.new(region).by_id(players_to_update(data))
    players.concat(new_players)

    data['entries'].each do |entry|
      summoner_ids.delete(entry['playerOrTeamId'].to_i)

      player = players.detect { |x| x.summoner_id == entry['playerOrTeamId'].to_i }
      if player
        PlayerLeagueBuilder.create_or_update(player, entry, region, league)
      end
    end
  end

  private

  def players_to_update(data)
    api_ids = data['entries'].map { |x| x['playerOrTeamId'] }
    existing_ids = players.map(&:summoner_id)

    api_ids - existing_ids
  end
end
