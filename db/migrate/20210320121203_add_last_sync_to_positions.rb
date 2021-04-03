class AddLastSyncToPositions < ActiveRecord::Migration[6.1]
  def change
    add_column :positions, :last_sync_at, :datetime
  end
end
