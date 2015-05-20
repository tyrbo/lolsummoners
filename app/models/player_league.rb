class PlayerLeague < ActiveRecord::Base
  belongs_to :player
  belongs_to :league
  after_save :update_ranking
  after_destroy :delete_ranking

  delegate :summoner_id, to: :player
  delegate :region, to: :player
  delegate :tier, to: :league

  private

  def update_ranking
    return unless league
    modified_points = League.points_for_ranking({'league_points' => league_points, 'tier' => league.tier, 'division' => division})
    Redis.current.pipelined do
      Redis.current.zadd("rank_#{region}", modified_points, "#{summoner_id}_#{region}")
      Redis.current.zadd("rank_all", modified_points, "#{summoner_id}_#{region}")
    end
  end

  def delete_ranking
    Redis.current.pipelined do
      Redis.current.zrem("rank_#{region}", "#{summoner_id}_#{region}")
      Redis.current.zrem("rank_all", "#{summoner_id}_#{region}")
    end
  end
end
