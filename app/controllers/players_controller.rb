class PlayersController < ApplicationController
  def show
    @player = Player.summoner_id_and_region(params[:summoner_id], params[:region]).first
    if @player
      @update = SearchWorker.queue(region: params[:region], id: params[:summoner_id], by: :name)
    end
  end
end
