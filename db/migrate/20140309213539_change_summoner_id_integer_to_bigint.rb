class ChangeSummonerIdIntegerToBigint < ActiveRecord::Migration
  def change
    change_column :players, :summoner_id, :bigint
  end
end
