class AddIsSterlingToAssets < ActiveRecord::Migration[6.1]
  def change
    add_column :assets, :sterling, :boolean
  end
end
