class PlayerUpdater
  def initialize(region)
    @api = RiotApi.new(region)
    @region = region
  end

  def by_name(values)
    response = []
    values.each_slice(50) do |names|
      response << @api.by_name(names)
    end
    update(response)
    response
  end

  def by_id(values)
    response = []
    values.each_slice(2) do |ids|
      response << @api.by_summoner_id(ids)
    end
    update(response)
    response
  end

  def update(response)
    response.each do |batch|
      batch.each do |player|
        PlayerBuilder.create_or_update(player.last, @region, nil)
      end
    end
  end
end
