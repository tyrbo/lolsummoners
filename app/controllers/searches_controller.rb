class SearchesController < ApplicationController
  before_action :rate_limited?, :prepare_params

  def show
    if params[:region].blank? || params[:name].blank?
      flash[:error] = 'You need to specify a name to search for.'
      redirect_to root_path
    else
      player = Player.name_and_region(params[:name], params[:region]).first
      if player
        redirect_to player_path(region: player.region, summoner_id: player.summoner_id)
      else
        SearchWorker.queue(region: params[:region], id: params[:name], by: :name, caller: :search)
        @region = params[:region]
        @name = params[:name]
      end
    end
  end

  private

  def prepare_params
    params[:name] = params[:name].to_s.downcase.gsub(/\s+/, '')
  end

  def rate_limited?
    key = "#{request.remote_ip}_#{Time.now.to_i}"
    if RateLimit.new(key).limited?
      render status: 429, text: 'You\'re doing that too much.'
    else
      RateLimit.new(key).limit!
    end
  end
end
