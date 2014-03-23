class LeaguesController < ApplicationController
  def show
    @league = League.id_and_region(params[:id], params[:region]).first
    @players = player_hash(@league.players)
  end

  private

  def player_hash(players)
    hash = {
      'I' => [],
      'II' => [],
      'III' => [],
      'IV' => [],
      'V' => []
    }
    players.each do |player|
      hash[player.rank] << player
    end
    hash
  end
end
