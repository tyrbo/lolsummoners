class SearchesController < ApplicationController
  before_action :prepare_params
  before_action :rate_limited?

  def show
    ApiHandler.new(params[:region]).player_search(params[:name])
    @player = Player.name_and_region(params[:name], params[:region]).first
    if @player
      redirect_to player_path(summoner_id: @player.summoner_id, region: @player.region)
    else
      render status: 404, text: 'Not Found'
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
    if redis.get(key_name)
      render status: 429, text: 'Too much'
    else
      redis.multi do
        redis.incr(key_name)
        redis.expire(key_name, 1)
      end
    end
  end

  def redis
    Redis.current
  end
end
