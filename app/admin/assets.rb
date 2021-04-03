ActiveAdmin.register Asset do
  includes :category
  permit_params :name, :source, :category_id, :symbol, :exchange, :currency, :sterling

  index do
    selectable_column
    column :symbol
    column :category, sortable: 'categories.name'
    column :name
    column :source
    column :currency
    
    column :updated_at

    actions
  end

  batch_action :set_category, form: -> { {category: Category.all.map { |category| [category.name, category.id] } } } do |ids, inputs|
    Asset.where(id: ids).update_all(category_id: inputs[:category])
    
    redirect_to admin_assets_path
  end

  form do |f|
    inputs 'Details' do
      input :name
      input :symbol
      input :currency
      input :sterling
      input :exchange
    end
    inputs 'Meta' do
      input :category
      input :source, as: :select, collection: Asset.sources
    end
    actions
  end
end
