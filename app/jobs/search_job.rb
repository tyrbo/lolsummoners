require 'job_events'

class SearchJob < ActiveJob::Base
  include JobEvents::SearchResult

  attr_reader :api

  def perform(region, name)
    player = perform_with_error_handling(region, name) do
      PlayerUpdater.update_by_name(region, name)
    end

    PlayerLeagueUpdater.update(player)

    fire_event(200, region, name, player.summoner_id)
  end

  private

  def perform_with_error_handling(region, name)
    @api = RiotApi.new(region)

    begin
      yield
    rescue RiotApi::NotFoundCode
      fire_event(404, region, name)
      return
    rescue RiotApi::InvalidStatusCode
      fire_event(500, region, name)
      return
    end
  end
end
