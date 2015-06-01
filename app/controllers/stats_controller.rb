class StatsController < ApplicationController
  def show
    @stats = stats_hash(Stats.by_region(params[:region]))
  end

  private

  def stats_hash(stats)
    stats.each_with_object({}) { |stat, h| h[stat.name] = JSON.parse(stat.value) )
  end
end
