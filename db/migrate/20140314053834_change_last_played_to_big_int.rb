class ChangeLastPlayedToBigInt < ActiveRecord::Migration
  def change
    change_column :player_leagues, :last_played, :bigint
  end
end
