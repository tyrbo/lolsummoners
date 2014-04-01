class PlayerLeague < ActiveRecord::Base
  belongs_to :player
  belongs_to :league
  after_save :update_ranking

  delegate :summoner_id, to: :player
  delegate :region, to: :player

  def self.player_to_update
    where('updated_at < ?', 30.minutes.ago)
      .first
  end

  private

  def update_ranking
    modified_points = League.points_for_ranking({'league_points' => league_points, 'tier' => tier, 'rank' => rank})
    Redis.current.pipelined do
      Redis.current.zadd("rank_#{region}", modified_points, "#{player_or_team_id}_#{region}")
      Redis.current.zadd("rank_all", modified_points, "#{player_or_team_id}_#{region}")
    end
  end
end
