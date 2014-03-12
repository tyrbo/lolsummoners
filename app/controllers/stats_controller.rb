class StatsController < ApplicationController
  def show
    @stats = stats_hash(Stats.by_region(params[:region]))
  end

  private

  def stats_hash(stats)
    hash = {}
    stats.each do |stat|
      hash[stat.name] = stat.value
    end
    hash
  end
end
