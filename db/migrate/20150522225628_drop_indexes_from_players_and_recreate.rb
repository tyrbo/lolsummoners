class DropIndexesFromPlayersAndRecreate < ActiveRecord::Migration
  def change
    remove_index :players, [:internal_name, :region]
    remove_index :players, [:summoner_id, :region]
    add_index :players, :internal_name
    add_index :players, :summoner_id
    add_index :players, :region
  end
end
