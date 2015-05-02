require 'job_events'

class PlayerLeagueJob < ActiveJob::Base
  include JobEvents::SearchResult

  queue_as :default

  attr_reader :player, :should_notify

  def perform(player, should_notify)
    @player = player
    @should_notify = should_notify

    perform_with_error_handling do
      result = api.league_for_full([player.summoner_id])
      if data = result[player.summoner_id.to_s].detect { |x| x["queue"] == "RANKED_SOLO_5x5" }
        league = LeagueBuilder.create_or_find(data, player.region)
        PlayerLeagueBuilder.create_or_update(player, data["entries"].detect { |x| x["playerOrTeamId"] == player.summoner_id.to_s }, player.region, league)
      end

      fire_event(200, player.region, player.internal_name, player.summoner_id) if should_notify
    end
  end

  private

  def perform_with_error_handling(&block)
    begin
      yield
    rescue RiotApi::NotFoundCode
      fire_event(200, player.region, player.internal_name, player.summoner_id) if should_notify
    end
  end

  def api
    @api ||= RiotApi.new(player.region)
  end
end
