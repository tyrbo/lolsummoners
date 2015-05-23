class Player < ActiveRecord::Base
  scope :name_and_region, ->(internal_name, region) {
    where(internal_name: internal_name, region: region)
  }

  scope :summoner_id_and_region, ->(summoner_id, region) {
    where(summoner_id: summoner_id, region: region)
  }

  scope :region_tier_and_division_count, ->(region, tier, division) {
    includes(player_league: :league).
    where(region: region).
    where(player_leagues: { division: division }).
    where(leagues: { tier: tier }).
    count
  }

  attr_accessor :rank
  delegate :wins, to: :player_league
  delegate :division, to: :player_league
  delegate :tier, to: :player_league
  delegate :league_points, to: :player_league
  delegate :league_id, to: :player_league
  delegate :is_veteran, to: :player_league
  delegate :is_hot_streak, to: :player_league
  delegate :is_fresh_blood, to: :player_league
  delegate :mini_series, to: :player_league
  has_one :player_league, dependent: :destroy
  before_save :prepare_name

  def self.find_players_to_update(time = 1.hours.ago)
    eager_load(:player_league).
      where('player_leagues.updated_at < ? and player_leagues.is_inactive = false', time).
      limit(100)
  end

  def self.find_players_by_region(players)
    arranged_players(players).map do |region, summoners|
      Player.where(summoner_id: summoners, region: region)
    end.flatten
  end

  def self.arranged_players(players)
    players.each_with_object({}) do |(key, _), obj|
      summoner_id, region = key.split('_')
      obj[region] ||= []
      obj[region] << summoner_id
    end
  end

  def limit!
    Redis.current.set("limit_#{id}", true, ex: 86400)
  end

  def limited?
    Redis.current.exists("limit_#{id}")
  end

  private

  def prepare_name
    self.internal_name = self.name.downcase.gsub(/\s+/, '')
  end
end
