class Api::Summoner
  attr_reader :region

  def initialize(args, region)
    @args = args
    @region = region
  end

  def name
    @args.fetch("name")
  end

  def profile_icon_id
    @args.fetch("profileIconId", nil)
  end

  def revision_date
    revision_date_in_seconds = @args.fetch("revisionDate") / 1000

    Time.at(revision_date_in_seconds).to_datetime
  end

  def summoner_id
    @args.fetch("id")
  end

  def summoner_level
    @args.fetch("summonerLevel")
  end

  def to_ar
    ::Summoner.find_or_create_by(summoner_id: summoner_id, region: region).tap do |x|
      x.update(
        name: name,
        profile_icon_id: profile_icon_id,
        revision_date: revision_date,
        summoner_level: summoner_level
      )
    end
  end
end
