class CreateLeague < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :queue
      t.string :tier
      t.string :region
    end

    add_index :leagues, :name
    add_index :leagues, :region
  end
end
