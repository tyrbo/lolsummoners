class Summoner < ActiveRecord::Base
  before_destroy :delete_ranking!
  before_save :internalize_name

  delegate :adjusted_points, :division, :league_points, :wins, to: :league_entry
  delegate :tier, to: :league

  has_one :league, through: :league_entry
  has_one :league_entry, dependent: :destroy

  def delete_ranking!
    redis.zrem("rank_#{region}", id)
    redis.zrem("rank_all", id)
  end

  def rank(region: "all")
    @rank ||= redis.zrevrank("rank_#{region}", id)
  end

  def update_ranking!
    return if !league_entry

    redis.zadd("rank_#{region}", adjusted_points, id)
    redis.zadd("rank_all", adjusted_points, id)
  end

  private

  def internalize_name
    return unless self.name

    self.internal_name = self.name.downcase.gsub(/\s+/, "")
  end

  def redis
    Redis.current
  end
end
