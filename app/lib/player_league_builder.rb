require 'rehash'

class PlayerLeagueBuilder
  def self.create_or_update(player, attributes, region, league)
    attributes['league_id'] = league.id
    attributes = prepare_attributes(attributes)

    if player.player_league.nil?
      player.create_player_league(attributes)
    else
      player.player_league.assign_attributes(attributes)
      if player.player_league.changed?
        player.player_league.save
      end
    end
    player.player_league
  end

  def self.prepare_attributes(attributes)
    attributes = Rehash.remap_hash(attributes)
    attributes['mini_series'] = stringify_mini_series(attributes['mini_series'])
    attributes['league_points'] = 110 if !attributes['mini_series'].nil?
    attributes.delete('league_name')
    attributes
  end

  def self.stringify_mini_series(series)
    if series
      "#{series['target']},0,#{series['wins']},#{series['losses']}"
    end
  end
end
