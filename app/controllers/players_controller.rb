class PlayersController < ApplicationController
  def show
    @player = Player.summoner_id_and_region(params[:summoner_id], params[:region]).first
  end
end
