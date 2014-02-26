class Region
  def self.available?(region)
    return true if region == 'all'
    $regions.include?(region)
  end
end
