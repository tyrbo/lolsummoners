class LeaguesController < ApplicationController
  def show
    @league = League.includes(players: :player_league).find(params[:id])
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
      hash[player.division] << player
    end
    hash
  end
end
