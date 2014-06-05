require 'rehash'

class PlayerBuilder
  PLAYER_MAPPINGS = { 'id' => 'summoner_id' }

  def self.create_or_update(attributes, region, player = nil)
    attributes = Rehash.remap_hash(attributes, PLAYER_MAPPINGS)
    player = Player.find_or_initialize_by(summoner_id: attributes['summoner_id'], region: region) unless player
    player.update_attributes(attributes) if has_changed(player, attributes)
    player
  end

  def self.has_changed(player, attributes)
    return true if player.name != attributes['name']
    return true if player.summoner_level != attributes['summoner_level']
    return true if player.profile_icon_id != attributes['profile_icon_id']
    false
  end
end
