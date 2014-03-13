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

  def roman_to_numeral(roman)
    case roman
    when 'I'
      1
    when 'II'
      2
    when 'III'
      3
    when 'IV'
      4
    when 'V'
      5
    end
  end

  def rank_for(region, player)
    Ladder.rank_for(region, player)
  end
end
