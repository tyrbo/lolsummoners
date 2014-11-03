class Region
  attr_reader :key

  def initialize(region)
    @key = region.downcase
  end

  def available?
    return true if key == 'all'
    REGIONS.key?(key)
  end

  def name
    return 'Global' if key == 'all'
    REGIONS[key][:name]
  end

  def base_url
    "https://#{key}.api.pvp.net"
  end
end
