class StatsUpdater
  attr_reader :region
  TIERS = ['BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'DIAMOND', 'MASTER', 'CHALLENGER']

  def initialize(region)
    @region = region
  end

  def update
    total = TIERS.reduce(0) { |sum, tier| sum += update_tier(tier) }
    Redis.current.set("total_#{region}", total)
    total
  end

  def update_tier(tier)
    counts = counts_for_tier(tier)
    counts["total"] = counts.values.reduce(0, :+)

    stats = Stats.find_or_initialize_by(region: region, name: tier.downcase)
    stats.value = counts.to_json
    stats.save

    counts["total"]
  end

  private

  def counts_for_tier(tier)
    PlayerLeague.joins(:league)
      .group(:division)
      .where(leagues: { tier: tier, region: region })
      .count(:division)
  end
end
