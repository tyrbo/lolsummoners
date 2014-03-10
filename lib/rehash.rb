module Rehash
  def self.remap_hash(attributes, mappings = {})
    Hash[attributes.map {|k, v| [mappings[k] || k.underscore, v]}]
  end
end
