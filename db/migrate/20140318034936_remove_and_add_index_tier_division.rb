class RemoveAndAddIndexTierDivision < ActiveRecord::Migration
  def change
    remove_index :player_leagues, :tier
    add_index :player_leagues, [:tier, :rank]
  end
end
