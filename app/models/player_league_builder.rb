require 'rehash'

class PlayerLeagueBuilder
  def self.create_or_update(player, attributes, region, league = nil)
    attributes['league_id'] =
      league || LeagueBuilder.create_or_update(attributes['leagueName'], attributes['tier'], attributes['queueType'], region)
    attributes = prepare_attributes(attributes)
    if player.player_league.nil?
      player.create_player_league(attributes)
    else
      if has_changed(player.player_league, attributes)
        player.player_league.update_attributes(attributes)
      else
        player.player_league.touch
      end
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

  def self.has_changed(player, attributes)
    return true if player.is_fresh_blood != attributes['is_fresh_blood']
    return true if player.is_hot_streak != attributes['is_hot_streak']
    return true if player.is_inactive != attributes['is_inactive']
    return true if player.is_veteran != attributes['is_veteran']
    return true if player.league_points != attributes['league_points']
    return true if player.mini_series != attributes['mini_series']
    return true if player.player_or_team_name != attributes['player_or_team_name']
    return true if player.rank != attributes['rank']
    return true if player.tier != attributes['tier']
    return true if player.wins != attributes['wins']
    return true if player.league_id != attributes['league_id']
    false
  end
end
