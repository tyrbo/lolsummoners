class Stats < ActiveRecord::Base
  scope :by_region, ->(region) {
    where(region: region)
  }

  def self.update
    all = { bronze: {}, silver: {}, gold: {}, platinum: {}, diamond: {}, challenger: {} }

    REGIONS.each do |region, _|
      all = update_stats_for_region(region, all)
    end

    all.each do |tier, values|
      stat = Stats.find_or_initialize_by(region: 'all', name: tier)
      stat.value = values.to_json
      stat.save
    end

    update_count
  end

  def self.update_stats_for_region(region, hash)
    tiers = ['BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'DIAMOND', 'CHALLENGER']
    tiers.each do |tier|
      stat = Stats.find_or_initialize_by(region: region, name: tier.downcase)
      stats = {}
      unless tier == 'CHALLENGER'
        stats[:I] = Player.region_tier_and_division_count(region, tier, 'I')
        stats[:II] = Player.region_tier_and_division_count(region, tier, 'II')
        stats[:III] = Player.region_tier_and_division_count(region, tier, 'III')
        stats[:IV] = Player.region_tier_and_division_count(region, tier, 'IV')
        stats[:V] = Player.region_tier_and_division_count(region, tier, 'V')
        stats[:total] = stats[:I] + stats[:II] + stats[:III] + stats[:IV] + stats[:V]
      else
        stats[:I] = Player.region_tier_and_division_count(region, tier, 'I')
        stats[:total] = stats[:I]
      end
      stat.value = stats.to_json
      stat.save
      hash = combine_stats(tier, stats, hash)
    end
    hash
  end

  def self.combine_stats(tier, stats, hash)
    tier = tier.downcase.to_sym
    stats.each do |k, v|
      hash[tier][k] = 0 if hash[tier][k].nil?
      hash[tier][k] = hash[tier][k] + v
    end
    hash
  end

  def self.update_count
    total_count = 0
    REGIONS.each do |region, _|
      count = 0
      Stats.by_region(region).each do |stat|
        json = JSON.parse(stat.value)
        count = count + json['total']
        total_count = total_count + json['total']
      end
      Redis.current.set("total_#{region}", count)
    end
    Redis.current.set('total_all', total_count)
  end
end
