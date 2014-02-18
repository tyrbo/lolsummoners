class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :summoner_id
      t.string :name
      t.integer :profile_icon_id
      t.integer :revision_date
      t.integer :summoner_level

      t.timestamps
    end
  end
end
