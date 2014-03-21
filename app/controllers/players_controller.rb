require 'is_bot'

class PlayersController < ApplicationController
  def show
    @player = Player.summoner_id_and_region(params[:summoner_id], params[:region]).first
    if @player && !IsBot::is_bot?(request)
      @update = SearchWorker.queue(region: @player.region, id: @player.internal_name, by: :name, caller: :player)
    end
  end
end
