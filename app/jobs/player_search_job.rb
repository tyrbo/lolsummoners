class PlayerSearchJob < ActiveJob::Base
  queue_as :default

  attr_reader :region, :name

  def perform(region, name)
    @region = region
    @name = name

    api = RiotApi.new(region)

    player = perform_with_error_handling do
      result = api.by_name([name])[name]
      PlayerBuilder.create_or_update(result, region)
    end

    result = api.league_for_full([player.summoner_id])
    if data = result[player.summoner_id.to_s].detect { |x| x["queue"] == "RANKED_SOLO_5x5" }
      league = LeagueBuilder.create_or_find(data, region)
      PlayerLeagueBuilder.create_or_update(player, data["entries"].detect { |x| x["playerOrTeamId"] == player.summoner_id.to_s }, region, league)
    end

    fire_event(200, player.summoner_id)
  end

  def perform_with_error_handling(&block)
    begin
      yield
    rescue RiotApi::NotFoundCode
      fire_event(404)
    rescue RiotApi::InvalidStatusCode
      fire_event(500)
    end
  end

  def fire_event(status, id = nil)
    Pusher["search_#{region}_#{name}"].trigger('my_event', {
      status: status,
      id: id
    })
  end
end
