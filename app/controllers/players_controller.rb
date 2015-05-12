require 'is_bot'

class PlayersController < ApplicationController
  def show
    @player = Player.summoner_id_and_region(params[:summoner_id], params[:region]).first
    if @player
      if @player.updated_at < 30.minutes.ago && !IsBot::is_bot?(request)
        #@update = SearchWorker.queue(region: @player.region, id: @player.summoner_id, by: :sid, caller: :player)
      end
    else
      flash[:error] = 'Player not found.'
      redirect_to root_path
    end
  end
end
