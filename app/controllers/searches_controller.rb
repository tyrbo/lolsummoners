class SearchesController < ApplicationController
  before_action :require_params
  before_action :prepare_params

  def show
    @player = Player.name_and_region(params[:name], params[:region]).first
    redirect_to player_path(summoner_id: @player.summoner_id, region: @player.region)
  end

  private

  def require_params
    params.require(:name)
    params.require(:region)
  end

  def prepare_params
    params[:name].downcase!.gsub!(/\s+/, '')
    params[:region].downcase!
  end
end
