class AddCompoundIndexesToPlayers < ActiveRecord::Migration
  def change
    remove_index :players, :internal_name
    remove_index :players, :summoner_id
    remove_index :players, :region
    add_index :players, [:internal_name, :region]
    add_index :players, [:summoner_id, :region]
  end
end
