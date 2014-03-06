class AddPlayerIdIndexToPlayerLeagues < ActiveRecord::Migration
  def change
    add_index :player_leagues, :player_id
  end
end
