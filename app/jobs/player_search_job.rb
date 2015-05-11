require 'job_events'

class PlayerSearchJob < ActiveJob::Base
  include JobEvents::SearchResult

  queue_as :default

  attr_reader :region

  def perform(region, name)
    @region = region

    player = perform_with_error_handling(name) do
      result = api.by_name([name])[name]
      PlayerBuilder.create_or_update(result, region)
    end

    PlayerLeagueJob.perform_later(player, true) if player
  end

  private

  def perform_with_error_handling(name)
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

  def api
    @api ||= RiotApi.new(region)
  end
end
