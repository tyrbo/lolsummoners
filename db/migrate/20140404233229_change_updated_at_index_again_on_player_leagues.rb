class ChangeUpdatedAtIndexAgainOnPlayerLeagues < ActiveRecord::Migration
  def change
    remove_index :player_leagues, [:id, :updated_at]
    add_index :player_leagues, [:id, :updated_at, :is_inactive]
  end
end
