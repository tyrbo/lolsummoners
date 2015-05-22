class AddDivisionIndexToPlayerLeagues < ActiveRecord::Migration
  def change
    add_index :player_leagues, :division
  end
end
