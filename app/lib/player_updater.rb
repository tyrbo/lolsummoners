class PlayerUpdater
  def self.update_by_name(region, name, player = nil)
    api = RiotApi.new(region)
    result = api.by_name(name)

    if result.include?(name)
      PlayerBuilder.create_or_update(result[name], region, player)
    end
  end

  def self.update_by_summoner_id(region, summoner_id, player = nil)
    api = RiotApi.new(region)
    result = api.by_summoner_id(summoner_id)

    if result.include?(summoner_id.to_s)
      PlayerBuilder.create_or_update(result[summoner_id.to_s], region, player)
    end
  end
end
