require 'curb'

class RiotApi
  def initialize(region)
    @region = region
    @has_api = Region.api?(@region)
  end

  def by_name(name)
    escaped_name = CGI::escape(name)
    response = get("v1.4/summoner/by-name/#{escaped_name}")
    handle_summoner(response, name)
  end

  def by_summoner_id(summoner_id)
    response = get("v1.4/summoner/#{summoner_id}")
    handle_summoner(response, summoner_id)
  end

  def league_for(summoner_id)
    response = get("v2.3/league/by-summoner/#{summoner_id}/entry")
    if !response.nil?
      if response.response_code == 200
        leagues = JSON.parse(response.body_str)
        [leagues.detect { |league| league['queueType'] == 'RANKED_SOLO_5x5' }, 200]
      else
        [nil, response.response_code]
      end
    else
      [nil, 0]
    end
  end

  def league_for_full(summoner_id)
    response = get("v2.3/league/by-summoner/#{summoner_id}")
    if !response.nil?
      if response.response_code == 200
        leagues = JSON.parse(response.body_str)
        league = leagues.detect { |league| league['queue'] == 'RANKED_SOLO_5x5' }
        [league, 200]
      else
        [nil, response.response_code]
      end
    else
      [nil, 0]
    end
  end

  private

  def handle_summoner(response, arg)
    arg = arg.to_s
    if !response.nil?
      if response.response_code == 200
        player = JSON.parse(response.body_str)
        [player[arg], 200]
      else
        [nil, response.response_code]
      end
    else
      [nil, 0]
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
