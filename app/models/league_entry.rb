class LeagueEntry < ActiveRecord::Base
  belongs_to :league
  belongs_to :summoner

  delegate :tier, to: :league

  def adjusted_points
    self.league_points + tier_points + division_points
  end

  private

  def tier_points
    tiers = %w(BRONZE SILVER GOLD PLATINUM DIAMOND MASTER CHALLENGER)
    tiers.index(tier) * 5000
  end

  def division_points
    divisions = %w(V IV III II I)
    divisions.index(division) * 1000
  end
end
