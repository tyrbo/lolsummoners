class Stats < ActiveRecord::Base
  scope :by_region, ->(region) { where(region: region) }

  def self.total_for(region)
    totals[region] ||= by_region(region).reduce(0) do |sum, stats|
      sum += JSON.parse(stats.value)["total"]
    end
  end

  private

  def self.totals
    @totals ||= {}
  end
end
