class League < ActiveRecord::Base
  has_many :player_leagues, -> { order 'league_points DESC' }
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
    points + add_points_for_tier(attributes['tier']) + add_points_for_rank(attributes['division'])
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
    when 'MASTER'
      25000
    when 'CHALLENGER'
      30000
    end
  end

  def self.add_points_for_rank(division)
    case division
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

  def self.rank_from_points(points)
    adjusted_points = points % 5000
    case
    when adjusted_points >= 3900
      'I'
    when adjusted_points >= 2900
      'II'
    when adjusted_points >= 1900
      'III'
    when adjusted_points >= 900
      'IV'
    when adjusted_points < 900
      'V'
    end
  end
end
