class CreateLeague < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :queue
      t.string :tier
    end
  end
end
