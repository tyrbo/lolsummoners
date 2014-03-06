class Region
  def self.available?(region)
    return true if region == 'all'
    REGIONS.include?(region)
  end
end
