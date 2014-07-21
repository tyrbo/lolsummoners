require 'curb'

class RiotApi
  def initialize(region)
    @region = region
  end

  def by_name(names)
    escaped_names = names.map { |n| CGI::escape(n) }.join(',')
    response = get("v1.4/summoner/by-name/#{escaped_names}")
    handle_response(response)
  end

  def by_summoner_id(summoner_ids)
    ids = summoner_ids.join(',')
    response = get("v1.4/summoner/#{ids}")
    handle_response(response)
  end

  def league_for(summoner_ids)
    ids = summoner_ids.join(',')
    response = get("v2.4/league/by-summoner/#{ids}/entry")
    handle_response(response)
  end

  def league_for_full(summoner_ids)
    ids = summoner_ids.join(',')
    response = get("v2.4/league/by-summoner/#{ids}")
    handle_response(response)
  end

  private

  def handle_response(response)
    if !response.nil?
      if response.response_code == 200
        JSON.parse(response.body_str)
      else
        {}
      end
    else
      {}
    end
  end

  def get(resource)
    begin
      address = build_url(resource)
      Curl.get(address)
    rescue StandardError => e
      puts e
    end
  end

  def build_url(resource)
    "#{base_url}/#{@region}/#{resource}?api_key=#{ENV['RIOT_API']}"
  end

  def base_url
    "#{Region.base_url(@region)}/api/lol"
  end
end
