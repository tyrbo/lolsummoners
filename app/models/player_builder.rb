require 'rehash'

class PlayerBuilder
  PLAYER_MAPPINGS = { 'id' => 'summoner_id' }

  def self.create_or_update(attributes, region)
    player = Player.find_or_initialize_by(summoner_id: attributes['id'], region: region)
    attributes = Rehash.remap_hash(attributes, PLAYER_MAPPINGS)
    player.update_attributes(attributes)
    player.save
    player
  end

  def self.create(attributes, region)
    player = Player.new
    attributes['region'] = region
    attributes = Rehash.remap_hash(attributes, PLAYER_MAPPINGS)
    player.update_attributes(attributes)
    player.save
    player
  end
end