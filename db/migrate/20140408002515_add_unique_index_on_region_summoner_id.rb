class AddUniqueIndexOnRegionSummonerId < ActiveRecord::Migration
  def change
    remove_index :players, [:summoner_id, :region]
    remove_index :player_leagues, :player_id
    add_index :players, [:summoner_id, :region], unique: true
    add_index :player_leagues, :player_id, unique: true
  end
end
