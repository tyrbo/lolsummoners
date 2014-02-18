class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :queue
      t.string :tier
      t.string :region

      t.timestamps
    end
  end
end
