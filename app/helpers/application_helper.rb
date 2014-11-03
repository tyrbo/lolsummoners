module ApplicationHelper
  def get_stats(region)
    stats_hash(Stats.by_region(params[:region]))
  end

  def stats_hash(stats)
    hash = {}
    total = 0
    stats.each do |stat|
      hash[stat.name] = JSON.parse(stat.value)
      total = total + hash[stat.name]['total']
    end
    hash['total'] = total
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

  def total_for(region)
    Redis.current.get("total_#{region}").to_f
  end

  def percentage_for(region, rank)
    percentage = rank / total_for(region).to_f
    percentage = percentage * 100
    percentage = 0.01 if percentage < 0.01
    number_with_precision(percentage, precision: 2)
  end

  def name_for_region(region)
    Region.new(region).name
  end
end
