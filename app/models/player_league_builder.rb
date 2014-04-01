require 'rehash'

class PlayerLeagueBuilder
  def self.create_or_update(player, attributes, region, league=nil)
    attributes['league_id'] =
      league || LeagueBuilder.create_or_update(attributes['leagueName'], attributes['tier'], attributes['queueType'], region)
    attributes = prepare_attributes(attributes)
    if player.player_league.nil?
      player.create_player_league(attributes)
    else
      player.player_league.update_attributes(attributes)
    end
  end

  def self.prepare_attributes(attributes)
    attributes = Rehash.remap_hash(attributes)
    attributes['mini_series'] = stringify_mini_series(attributes['mini_series'])
    attributes['league_points'] = 110 unless attributes['mini_series'].nil?
    attributes.delete('league_name')
    attributes
  end

  def self.stringify_mini_series(series)
    unless series.nil?
      "#{series['target']},#{series['timeLeftToPlayMillis']},#{series['wins']},#{series['losses']}"
    else
      nil
    end
  end
end
