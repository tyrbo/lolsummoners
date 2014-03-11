class Region
  def self.available?(region)
    return true if region == 'all'
    REGIONS.key?(region.to_sym)
  end

  def self.name(region)
    return 'Global' if region == 'all'
    REGIONS[region.to_sym][:name]
  end

  def self.api?(region)
    return false unless self.available?(region)
    REGIONS[region.to_sym][:has_api]
  end
end
