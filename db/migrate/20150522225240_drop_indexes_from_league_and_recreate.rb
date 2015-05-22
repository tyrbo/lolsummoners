class DropIndexesFromLeagueAndRecreate < ActiveRecord::Migration
  def change
    remove_index :leagues, [:name, :tier, :queue, :region]
    add_index :leagues, :name
    add_index :leagues, :tier
    add_index :leagues, :queue
    add_index :leagues, :region
  end
end
