class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.belongs_to :asset, null: false, foreign_key: true
      t.float :amount
      t.date :open_date
      t.monetize :open_value
      t.monetize :market_value
      t.string :hash_id

      t.timestamps
    end
  end
end
