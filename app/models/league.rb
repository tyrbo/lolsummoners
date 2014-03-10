class League < ActiveRecord::Base
  has_many :player_leagues
  has_many :players, through: :player_leagues

  def self.set_rank(region, summoner_id, attributes)
    modified_points = points_for_ranking(attributes)
    Redis.current.multi do
      Redis.current.zadd("rank_#{region}", modified_points, "#{summoner_id}_#{region}")
      Redis.current.zadd("rank_all", modified_points, "#{summoner_id}_#{region}")
    end
  end

  def self.points_for_ranking(attributes)
    points = attributes['league_points']
    points + add_points_for_tier(attributes['tier']) + add_points_for_rank(attributes['rank'])
  end

  def self.add_points_for_tier(tier)
    case tier
    when 'BRONZE'
      0
    when 'SILVER'
      5000
    when 'GOLD'
      10000
    when 'PLATINUM'
      15000
    when 'DIAMOND'
      20000
    when 'CHALLENGER'
      25000
    end
  end

  def self.add_points_for_rank(rank)
    case rank
    when 'I'
      4000
    when 'II'
      3000
    when 'III'
      2000
    when 'IV'
      1000
    when 'V'
      0
    end
  end
end
