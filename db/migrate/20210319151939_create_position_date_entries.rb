class CreatePositionDateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :position_date_entries do |t|
      t.belongs_to :position, null: false, foreign_key: true
      t.monetize :value
      t.monetize :exchange_value
      t.float :amount
      t.date :date

      t.timestamps
    end
  end
end
