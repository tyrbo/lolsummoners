class ChangeRevisionDateIntegerToBigint < ActiveRecord::Migration
  def change
    change_column :players, :revision_date, :bigint
  end
end
