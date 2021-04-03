class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :assets do |t|
      t.string :name
      t.string :currency, default: 'PLN'
      t.string :source
      t.references :category
      t.string :symbol
      t.string :exchange

      t.timestamps
    end
  end
end
