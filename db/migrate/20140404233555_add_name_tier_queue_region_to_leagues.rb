class AddNameTierQueueRegionToLeagues < ActiveRecord::Migration
  def change
    add_index :leagues, [:name, :tier, :queue, :region]
  end
end
