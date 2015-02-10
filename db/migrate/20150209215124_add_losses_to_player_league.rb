class AddLossesToPlayerLeague < ActiveRecord::Migration
  def change
    add_column :player_leagues, :losses, :integer
  end
end
