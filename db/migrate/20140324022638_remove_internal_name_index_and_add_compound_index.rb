class RemoveInternalNameIndexAndAddCompoundIndex < ActiveRecord::Migration
  def change
    remove_index :players, :internal_name
    add_index :players, [:internal_name, :region]
  end
end
