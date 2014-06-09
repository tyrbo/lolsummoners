require 'curb'

class RiotApi
  def initialize(region)
    @region = region
    @has_api = Region.api?(@region)
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
    response = get("v2.4/league/by-summoner/#{ids}/entry", true)
    handle_response(response)
  end

  def league_for_full(summoner_ids)
    ids = summoner_ids.join(',')
    response = get("v2.4/league/by-summoner/#{ids}", true)
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
      if @region == 'kr'
        'https://asia.api.pvp.net/api/lol'
      elsif @region == 'tr' || @region == 'ru'
        'https://eu.api.pvp.net/api/lol'
      else
        'https://prod.api.pvp.net/api/lol'
      end
    else
      'http://127.0.0.1:1337/api/lol'
    end
  end

end
