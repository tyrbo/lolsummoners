class RenameRankToDivisionPlayerLeagues < ActiveRecord::Migration
  def change
    rename_column :player_leagues, :rank, :division
  end
end
