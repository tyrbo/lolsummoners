class LeagueBuilder
  def self.create_or_update(name, tier, queue, region)
    league = League.find_or_initialize_by(name: name, tier: tier, queue: queue, region: region)
    league.save
    league
  end
end
