class ChangeValueColumn < ActiveRecord::Migration
  def change
    change_column :stats, :value, :string
  end
end
