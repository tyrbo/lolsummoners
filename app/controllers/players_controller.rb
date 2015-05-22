require 'is_bot'

class PlayersController < ApplicationController
  def show
    @player = Player.summoner_id_and_region(params[:summoner_id], params[:region]).first
    if @player
      if @player.updated_at < 30.minutes.ago && !IsBot::is_bot?(request)
        @update = true
      end
    else
      flash[:error] = 'Player not found.'
      redirect_to root_path
    end
  end

  def trigger
    return unless params[:summoner_id] && params[:region]

    PlayerJob.perform_later(params[:region], params[:summoner_id])

    render nothing: true
  end
end
