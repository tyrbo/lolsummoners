class PlayerUpdater
  def self.update_by_name(region, name)
    api = RiotApi.new(region)
    result = api.by_name(name)

    if result.include?(name)
      PlayerBuilder.create_or_update(result[name], region)
    end
  end
end
