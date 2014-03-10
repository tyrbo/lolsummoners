class AddLeagueIdIndexToPlayerLeagues < ActiveRecord::Migration
  def change
    add_index :player_leagues, :league_id
  end
end
