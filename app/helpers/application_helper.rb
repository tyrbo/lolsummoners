module ApplicationHelper
  def get_stats(region)
    stats_hash(Stats.by_region(params[:region]))
  end

  def stats_hash(stats)
    hash = {}
    stats.each do |stat|
      hash[stat.name] = stat.value
    end
    hash
  end
end
