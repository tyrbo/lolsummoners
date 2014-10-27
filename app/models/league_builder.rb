class LeagueBuilder
  def self.create_or_update(name, tier, queue, region)
    league = League.find_or_create_by(name: name, tier: tier, queue: queue, region: region)
    league
  end
end
