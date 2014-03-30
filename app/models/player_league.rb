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
    Redis.current.pipelined do
      Redis.current.zadd("rank_#{region}", league_points, "#{summoner_id}_#{region}")
      Redis.current.zadd("rank_all", league_points, "#{summoner_id}_#{region}")
    end
  end
end
