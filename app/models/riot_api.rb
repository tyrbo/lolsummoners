require 'net/http'

class RiotApi
  def initialize(region)
    @region = region
    @has_api = Region.api?(@region)
  end

  def by_name(name)
    escaped_name = CGI::escape(name)
    response = get("v1.3/summoner/by-name/#{escaped_name}")
    if !response.nil? && response.code == '200'
      player = JSON.parse(response.body)
      return player[name]
    else
      nil
    end
  end

  def league_for(summoner_id)
    response = get("v2.3/league/by-summoner/#{summoner_id}/entry")
    if !response.nil? && response.code == '200'
      leagues = JSON.parse(response.body)
      return leagues.detect { |league| league['queueType'] == 'RANKED_SOLO_5x5' }
    else
      nil
    end
  end

  private

  def get(resource)
    begin
      uri = URI(build_url(resource))
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 10
      http.use_ssl = true if @has_api
      return http.request(Net::HTTP::Get.new(uri))
    rescue StandardError => e
      puts e
      nil
    end
  end

  def build_url(resource)
    if @has_api
      "#{base_url}/#{@region}/#{resource}?api_key=#{ENV['RIOT_API']}"
    else
      "#{base_url}/#{@region}/#{resource}"
    end
  end

  def base_url
    if @has_api
      'https://prod.api.pvp.net/api/lol'
    else
      'http://127.0.0.1:1337/api/lol'
    end
  end

end
