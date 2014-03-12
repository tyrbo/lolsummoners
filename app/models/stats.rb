class Stats < ActiveRecord::Base
  scope :by_region, -> (region) {
    where(region: region)
  }

  def self.update
    all = { bronze: 0, silver: 0, gold: 0, platinum: 0, diamond: 0, challenger: 0 }
    REGIONS.each do |region, _|
      all[:bronze] = all[:bronze] + update_stat(region, 'BRONZE')
      all[:silver] = all[:silver] + update_stat(region, 'SILVER')
      all[:gold] = all[:gold] + update_stat(region, 'GOLD')
      all[:platinum] = all[:platinum] + update_stat(region, 'PLATINUM')
      all[:diamond] = all[:diamond] + update_stat(region, 'DIAMOND')
      all[:challenger] = all[:challenger] + update_stat(region, 'CHALLENGER')
    end

    all.each do |tier, value|
      stat = Stats.find_or_initialize_by(region: 'all', name: tier)
      stat.value = value
      stat.save
    end
  end

  def self.update_stat(region, tier)
    stat = Stats.find_or_initialize_by(region: region, name: tier.downcase)
    stat.value = Player.region_and_tier_count(region, tier)
    stat.save
    stat.value
  end
end
