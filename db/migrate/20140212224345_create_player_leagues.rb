class CreatePlayerLeagues < ActiveRecord::Migration
  def change
    create_table :player_leagues do |t|
      t.boolean :is_fresh_blood
      t.boolean :is_hot_streak
      t.boolean :is_inactive
      t.boolean :is_veteran
      t.integer :last_played
      t.integer :league_points
      t.string :mini_series
      t.string :player_or_team_id
      t.string :player_or_team_name
      t.string :queue_type
      t.string :rank
      t.string :tier
      t.integer :wins

      t.timestamps
    end
  end
end
