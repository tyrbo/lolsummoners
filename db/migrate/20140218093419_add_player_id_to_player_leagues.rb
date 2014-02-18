class AddPlayerIdToPlayerLeagues < ActiveRecord::Migration
  def change
    add_column :player_leagues, :player_id, :integer
  end
end
