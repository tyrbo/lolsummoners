class PlayerUpdater
  def initialize(region)
    @api = RiotApi.new(region)
    @region = region
  end

  def by_name(values)
    response = []
    values.each_slice(40) do |names|
      response << @api.by_name(names)
    end
    update(response)
  end

  def by_id(values)
    response = []
    values.each_slice(40) do |ids|
      response << @api.by_summoner_id(ids)
    end
    update(response)
  end

  def update(response)
    result = []
    response.each do |batch|
      batch.each do |player|
        result << PlayerBuilder.create_or_update(player.last, @region, nil)
      end
    end
    result
  end
end
