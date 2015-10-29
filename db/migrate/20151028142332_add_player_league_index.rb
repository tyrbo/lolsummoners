class AddPlayerLeagueIndex < ActiveRecord::Migration
  def change
    add_index :player_leagues, :league_points
  end
end
