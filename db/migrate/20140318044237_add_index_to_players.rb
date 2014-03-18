class AddIndexToPlayers < ActiveRecord::Migration
  def change
    add_index :players, :region
  end
end
