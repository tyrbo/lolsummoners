class CreateLeagueEntry < ActiveRecord::Migration
  def change
    create_table :league_entries do |t|
      t.string :division
      t.boolean :is_fresh_blood
      t.boolean :is_hot_streak
      t.boolean :is_inactive
      t.boolean :is_veteran
      t.integer :league_points
      t.integer :losses
      t.string :mini_series
      t.string :player_or_team_id
      t.string :player_or_team_name
      t.integer :wins

      t.references :summoner, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
