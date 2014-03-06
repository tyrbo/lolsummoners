class AddIndexToSummonerIdRegion < ActiveRecord::Migration
  def change
    add_index :players, [:summoner_id, :region]
  end
end
