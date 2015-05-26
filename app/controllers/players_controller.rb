require 'is_bot'

class PlayersController < ApplicationController
  before_action :find_player, :queue_update, :ensure_rank, only: [:show]

  def show
    if !@player
      flash[:error] = 'Player not found.'
      redirect_to root_path
    end
  end

  def trigger
    return unless params[:summoner_id] && params[:region]

    PlayerJob.perform_later(params[:region], params[:summoner_id])

    render nothing: true
  end

  private

  def find_player
    @player = Player.find_by(summoner_id: params[:summoner_id], region: params[:region])
  end

  def queue_update
    if @player && @player.updated_at < 30.minutes.ago && !IsBot::is_bot?(request)
      @update = true
    end
  end

  def ensure_rank
    if @player && @player.player_league
      if !Redis.current.zrank("rank_all", "#{@player.summoner_id}_#{@player.region}")
        @player.player_league.send(:update_ranking)
      end
    end
  end
end
