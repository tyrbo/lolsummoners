class AddRegionToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :region, :string
  end
end
