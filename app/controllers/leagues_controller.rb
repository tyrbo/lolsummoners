class LeaguesController < ApplicationController
  def show
    @league = League.id_and_region(params[:id], params[:region]).first
    @players = player_hash(@league.players.sort_by { |player| player.league_points }.reverse!)
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
