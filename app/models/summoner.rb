class Summoner < ActiveRecord::Base
  before_destroy :delete_ranking!
  before_save :internalize_name

  delegate :division, :league_points, :wins, to: :league_entry
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
    redis.zadd("rank_#{region}", league_points, id)
    redis.zadd("rank_all", league_points, id)
  end

  private

  def internalize_name
    self.internal_name = self.name.downcase.gsub(/\s+/, "")
  end

  def redis
    Redis.current
  end
end
