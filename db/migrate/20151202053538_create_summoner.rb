class CreateSummoner < ActiveRecord::Migration
  def change
    create_table :summoners do |t|
      t.integer :summoner_id
      t.string :name
      t.string :internal_name
      t.integer :profile_icon_id
      t.integer :revision_date
      t.integer :summoner_level
      t.string :region
    end
    add_index :summoners, :summoner_id
    add_index :summoners, :internal_name
    add_index :summoners, :region
  end
end
