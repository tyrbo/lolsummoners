require 'job_events'

class SearchJob < ActiveJob::Base
  include JobEvents::SearchResult

  def perform(region, name)
    begin
      player = PlayerUpdater.update_by_name(region, name)

      if player
        PlayerLeagueUpdater.update(player)

        fire_event(200, region, name, player.summoner_id)
      else
        fire_event(404, region, name)
      end
    rescue RiotApi::InvalidStatusCode
      fire_event(500, region, name)
    end
  end
end
