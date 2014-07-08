class RenameQueueTypeToQueue < ActiveRecord::Migration
  def change
    rename_column :player_leagues, :queue_type, :queue
  end
end
