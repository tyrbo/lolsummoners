class AddLeagueIdToPlayerLeagues < ActiveRecord::Migration
  def change
    add_column :player_leagues, :league_id, :integer
  end
end
