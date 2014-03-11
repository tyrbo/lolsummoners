class LeaguesController < ApplicationController
  def show
    @league = League.id_and_region(params[:id], params[:region]).first
    @players = @league.players.sort_by { |player| player.league_points }.reverse!
  end
end
