require 'rehash'

class PlayerLeagueBuilder
  def self.create_or_update(player, attributes, region)
    attributes['league_id'] =
      LeagueBuilder.create(attributes['leagueName'], attributes['tier'], attributes['queueType'], region)
    attributes = prepare_attributes(attributes)
    if player.player_league.nil?
      player.create_player_league(attributes)
    else
      player.player_league.update_attributes(attributes)
    end
    League.set_rank(region, player.summoner_id, attributes)
  end

  def self.prepare_attributes(attributes)
    attributes = Rehash.remap_hash(attributes)
    attributes['mini_series'] = stringify_mini_series(attributes['mini_series'])
    attributes.delete('league_name')
    attributes
  end

  def self.stringify_mini_series(series)
    unless series.nil?
      "#{series['target']},#{series['wins']},#{series['losses']},#{series['timeLeftToPlayMillis']}"
    else
      nil
    end
  end
end
