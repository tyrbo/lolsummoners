require 'job_events'

class PlayerJob < ActiveJob::Base
  include JobEvents::PlayerResult

  def perform(region, summoner_id)
    player = Player.find_by(region: region, summoner_id: summoner_id)

    if player
      player.touch

      begin
        updated = PlayerUpdater.update_by_summoner_id(player.region, player.summoner_id, player)

        if updated
          PlayerLeagueUpdater.update(player)

          fire_event(200, player.region, player.summoner_id)
        else
          fire_event(404, player.region, player.summoner_id)
        end
      rescue RiotApi::InvalidStatusCode
        fire_event(500, player.region, player.summoner_id)
      end
    end
  end
end
