class PlayerLeague < ActiveRecord::Base
  belongs_to :player
  belongs_to :league
  after_save :update_ranking

  delegate :summoner_id, to: :player
  delegate :region, to: :player

  def self.player_to_update
    includes(:player).
      where('player_leagues.updated_at < ?', 18.hours.ago)
      .first
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
