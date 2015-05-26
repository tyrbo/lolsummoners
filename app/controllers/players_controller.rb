require 'is_bot'

class PlayersController < ApplicationController
  def show
    @player = Player.find_by(summoner_id: params[:summoner_id], region: params[:region])

    if @player
      if @player.updated_at < 30.minutes.ago && !IsBot::is_bot?(request)
        @update = true
      end

      if @player.player_league
        if !Redis.current.zrank("rank_all", "#{@player.summoner_id}_#{@player.region}")
          @player.player_league.send(:update_ranking)
        end
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
