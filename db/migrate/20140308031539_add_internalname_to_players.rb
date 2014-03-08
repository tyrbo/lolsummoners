class AddInternalnameToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :internal_name, :string
    add_index :players, :internal_name
  end
end
