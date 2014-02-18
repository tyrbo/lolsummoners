class Player < ActiveRecord::Base
  attr_accessor :rank
  has_one :player_league

  def self.find_by_ranked_ids(redis_results)
    players, region = explode_redis_results(redis_results)
    Player.where(summoner_id: players)
  end

  private

  def self.explode_redis_results(redis_results)
    players, region = [], nil
    redis_results.each do |key, score|
      summoner_id, region = key.split('_')
      players << summoner_id
    end
    [players, region]
  end
end
