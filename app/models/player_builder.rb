require 'rehash'

class PlayerBuilder
  PLAYER_MAPPINGS = { 'id' => 'summoner_id' }

  def self.create_or_update(attributes, region, player = nil)
    attributes = Rehash.remap_hash(attributes, PLAYER_MAPPINGS)
    player = Player.find_or_initialize_by(summoner_id: attributes['summoner_id'], region: region) unless player
    player.assign_attributes(attributes)
    player.save if player.changed?
    player
  end
end
