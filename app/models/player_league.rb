class PlayerLeague < ActiveRecord::Base
  belongs_to :player
  belongs_to :league
  after_save :update_ranking

  delegate :summoner_id, to: :player
  delegate :region, to: :player

  def self.player_to_update(time = 1.hours.ago)
    includes(:player).
      where('updated_at < ? and is_inactive = false', time).
      order(nil)
  end

  private

  def update_ranking
    modified_points = League.points_for_ranking({'league_points' => league_points, 'tier' => tier, 'rank' => rank})
    Redis.current.pipelined do
      Redis.current.zadd("rank_#{region}", modified_points, "#{summoner_id}_#{region}")
      Redis.current.zadd("rank_all", modified_points, "#{summoner_id}_#{region}")
    end
  end
end
