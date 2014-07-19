class RemoveTierFromPlayerLeagues < ActiveRecord::Migration
  def change
    remove_column :player_leagues, :tier
  end
end
