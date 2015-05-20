class PlayerUpdater
  def self.update_by_name(region, name)
    api = RiotApi.new(region)
    result = api.by_name(name)[name]
    PlayerBuilder.create_or_update(result, region)
  end
end
