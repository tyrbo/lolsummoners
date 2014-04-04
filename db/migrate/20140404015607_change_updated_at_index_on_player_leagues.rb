class ChangeUpdatedAtIndexOnPlayerLeagues < ActiveRecord::Migration
  def change
    remove_index :player_leagues, :updated_at
    add_index :player_leagues, [:id, :updated_at]
  end
end
