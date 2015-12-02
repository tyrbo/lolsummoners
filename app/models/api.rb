class Api
  attr_reader :region

  def initialize(region:)
    @region = region
  end

  def find_by_name(names)
    names = Array(names)

    get("/v1.4/summoner/by-name/", clean(names))
      .map { |_, x| Api::Summoner.new(x, region) }
  end
  
  def find_league_by_summoner_id(summoner_ids)
    summoner_ids = Array(summoner_ids)

    get("/v2.5/league/by-summoner/", clean(summoner_ids)).map do |_, x|
      args = x.detect { |z| z["queue"] == "RANKED_SOLO_5x5" }

      Api::League.new(args, region) if args
    end
  end

  def region=(value)
    @region = value
    @conn = nil
  end

  private

  def api_key
    ENV["RIOT_API"]
  end

  def clean(values)
    values.map { |x| CGI::escape(x.to_s) }.join(",")
  end
  
  def conn
    @conn ||= Faraday.new(url: "https://#{region}.api.pvp.net")
  end

  def get(url, args)
    response = conn.get("/api/lol/#{region}/#{url}#{args}/?api_key=#{api_key}")

    if response.status == 200
      JSON.parse(response.body)
    else
      {}
    end
  end
end
