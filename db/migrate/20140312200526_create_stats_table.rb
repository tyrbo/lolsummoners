class CreateStatsTable < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :name
      t.integer :value
    end
  end
end
