class RemoveCompoundIndexFromLeagues < ActiveRecord::Migration
  def change
    remove_index :leagues, [:name, :region, :tier, :queue]
  end
end
