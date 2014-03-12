class AddRegionToStats < ActiveRecord::Migration
  def change
    add_column :stats, :region, :string
  end
end
