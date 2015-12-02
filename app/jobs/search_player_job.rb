class SearchPlayerJob < ActiveJob::Base
  queue_as :default

  def perform(name:, region:)
    summoner = Api.new(region: region).find_by_name(name).first

    if summoner
      summoner.to_ar

      update_league_entry(summoner)
    end
  end
  
  private

  def update_league_entry(summoner)
    league = Api.new(region: summoner.region).find_league_by_summoner_id(summoner.summoner_id).first

    if league
      league.to_ar(cascade: true)
    end
  end
end
