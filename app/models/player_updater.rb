class PlayerUpdater
  attr_reader :api, :region

  def initialize(api, region)
    @api = api
    @region = region
  end

  def by_name(values)
    response = values.each_slice(40).map do |names|
      api.by_name(names)
    end
    #update(response)
  end

  def by_id(values)
    values.each_slice(40).map do |ids|
      api.by_summoner_id(ids)
    end
    #update(response)
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
