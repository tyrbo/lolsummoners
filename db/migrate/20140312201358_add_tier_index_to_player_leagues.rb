class AddTierIndexToPlayerLeagues < ActiveRecord::Migration
  def change
    add_index :player_leagues, :tier
  end
end
