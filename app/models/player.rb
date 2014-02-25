class Player < ActiveRecord::Base
  attr_accessor :rank
  delegate :tier, to: :player_league
  delegate :wins, to: :player_league
  delegate :league_points, to: :player_league
  has_one :player_league

  def self.find_players_by_region(redis_results)
    results = []
    arranged_players = explode_redis_results(redis_results)
    arranged_players.each do |region, summoners|
      results << Player.where(summoner_id: summoners, region: region)
    end
    results.flatten
  end

  private

  def self.explode_redis_results(redis_results)
    players_by_region = {}
    redis_results.each do |key, score|
      summoner_id, region = key.split('_')
      players_by_region[region] ||= []
      players_by_region[region] << summoner_id
    end
    players_by_region
  end
end
