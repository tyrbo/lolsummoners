class PlayerDecorator < Draper::Decorator
  delegate_all

  def formatted_region
    region.upcase
  end

  def formatted_rank
    h.number_with_delimiter(rank)
  end

  def formatted_league_points
    h.number_with_delimiter(league_points)
  end

  def formatted_tier
    tier.capitalize
  end

  def percentile(region)
    percentage = rank / Stats.total_for(region).to_f
    percentage = percentage * 100
    percentage = 0.01 if percentage < 0.01

    h.number_with_precision(percentage, precision: 2)
  end
end
