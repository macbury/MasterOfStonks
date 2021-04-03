ActiveAdmin.register PositionDateEntry do
  belongs_to :position
  includes position: :asset

  index do
    selectable_column
    column :symbol, sortable: 'assets.symbol' do |entry|
      entry.position.asset.symbol
    end
    column :date, default: true
    column :amount
    column :value, sortable: 'value_cents' do |position|
      position.value.format
    end
    column :exchange_value, sortable: 'exchange_value_cents' do |position|
      position.exchange_value.format
    end
   
    actions
  end
end
