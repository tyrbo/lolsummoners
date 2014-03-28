class AddUpdatedAtIndexToPlayerLeagues < ActiveRecord::Migration
  def change
    add_index :player_leagues, :updated_at
  end
end
