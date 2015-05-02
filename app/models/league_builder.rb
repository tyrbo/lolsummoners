class LeagueBuilder
  def self.create_or_find(attributes, region)
    League.find_or_create_by(
      name: attributes["name"],
      tier: attributes["tier"],
      queue: attributes["queue"],
      region: region)
  end
end
