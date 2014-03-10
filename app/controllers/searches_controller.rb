class SearchesController < ApplicationController
  before_action :prepare_params
  before_action :rate_limited?

  def show
    player = Player.name_and_region(params[:name], params[:region]).first
    if player
      redirect_to player_path(region: player.region, summoner_id: player.summoner_id)
    else
      SearchWorker.queue(params[:region], params[:name])
      @region = params[:region]
      @name = params[:name]
    end
  end

  private

  def prepare_params
    params.require(:name)
    params.require(:region)
    params[:name] = params[:name].downcase.gsub(/\s+/, '')
  end

  def rate_limited?
    ip = request.remote_ip || 'unknown_ip'
    key_name = "#{ip}_#{Time.now.to_i}"
    if RateLimit.limited?(key_name)
      render status: 429, text: 'Too much'
    else
      RateLimit.set(key_name, 1)
    end
  end
end
