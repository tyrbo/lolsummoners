class Region
  def self.available?(region)
    return true if region == 'all'
    REGIONS.key?(region.to_sym)
  end
end
