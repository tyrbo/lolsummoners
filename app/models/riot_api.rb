require 'curb'

class RiotApi
  def initialize(region)
    @region = region
    @has_api = Region.api?(@region)
  end

  def by_name(name)
    escaped_name = CGI::escape(name)
    response = get("v1.3/summoner/by-name/#{escaped_name}")
    handle_summoner(response, name)
  end

  def by_summoner_id(summoner_id)
    response = get("v1.3/summoner/#{summoner_id}")
    handle_summoner(response, summoner_id)
  end

  def league_for(summoner_id)
    response = get("v2.3/league/by-summoner/#{summoner_id}/entry", true)
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
    response = get("v2.3/league/by-summoner/#{summoner_id}", true)
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

  def get(resource, bypass = false)
    begin
      address = build_url(resource, bypass)
      Curl.get(address)
    rescue StandardError => e
      puts e
      nil
    end
  end

  def build_url(resource, bypass)
    if @has_api || bypass
      "#{base_url(bypass)}/#{@region}/#{resource}?api_key=#{ENV['RIOT_API']}"
    else
      "#{base_url}/#{@region}/#{resource}"
    end
  end

  def base_url(bypass = false)
    if @has_api || bypass
      'https://prod.api.pvp.net/api/lol'
    else
      'http://127.0.0.1:1337/api/lol'
    end
  end

end
