class Player < ActiveRecord::Base
  scope :name_and_region, -> (internal_name, region) {
    where(internal_name: internal_name, region: region)
  }

  scope :summoner_id_and_region, -> (summoner_id, region) {
    where(summoner_id: summoner_id, region: region)
  }

  attr_accessor :ladder
  delegate :tier, to: :player_league
  delegate :wins, to: :player_league
  delegate :rank, to: :player_league
  delegate :league_points, to: :player_league
  has_one :player_league, dependent: :destroy
  before_save :prepare_name

  def self.find_players_by_region(player_list)
    results = []
    arranged_players = explode_redis_results(player_list)
    arranged_players.each do |region, summoners|
      results << Player.where(summoner_id: summoners, region: region)
    end
    results.flatten
  end

  private

  def prepare_name
    self.internal_name = self.name.downcase.gsub(/\s+/, '')
  end

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
