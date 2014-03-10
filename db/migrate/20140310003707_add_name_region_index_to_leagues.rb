class AddNameRegionIndexToLeagues < ActiveRecord::Migration
  def change
    add_index :leagues, [:name, :region, :tier, :queue]
  end
end
