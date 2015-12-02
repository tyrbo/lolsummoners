class Summoner < ActiveRecord::Base
  before_destroy :delete_ranking!
  before_save :internalize_name

  has_one :league_entry, dependent: :destroy

  def delete_ranking!
    redis.pipelined do
      redis.zrem("rank_#{region}", id)
      redis.zrem("rank_all", id)
    end
  end
  
  def points
    25
  end

  def rank(region: "all")
    @rank ||= redis.zrevrank("rank_#{region}", id)
  end

  def update_ranking!
    redis.pipelined do
      redis.zadd("rank_#{region}", points, id)
      redis.zadd("rank_all", points, id)
    end
  end

  private

  def internalize_name
    self.internal_name = self.name.downcase.gsub(/\s+/, "")
  end

  def redis
    Redis.current
  end
end
