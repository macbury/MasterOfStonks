ActiveAdmin.register Position do
  includes :asset, :account

  permit_params :asset_id, :amount, :open_date, :open_value, :amount, :market_value, :account_id

  scope :opened, group: :status, default: true
  scope :closed, group: :status

  batch_action :set_account, form: -> { {account: Account.all.map { |account| [account.name, account.id] } } } do |ids, inputs|
    Position.where(id: ids).update_all(account_id: inputs[:account])
    
    redirect_to admin_positions_path
  end

  index do
    selectable_column
    column :symbol, sortable: 'assets.symbol' do |position|
      position.asset.symbol
    end
    column :asset, sortable: 'assets.name'
    column :account, sortable: 'accounts.name'
    column :open_date
    column :open_value, sortable: 'open_value_cents' do |position|
      position.open_value.format
    end
    column :amount
    column :market_value, sortable: 'market_value_cents' do |position|
      if position.market_value.currency === "PLN"
        position.market_value.format
      else
        position.market_value.format + "\n(#{ExchangeWith.call(position.market_value).format})"
      end
    end
    column :net do |position|
      if position.diffrence.currency === "PLN"
        position.diffrence.format
      else
        position.diffrence.format + "\n(#{ExchangeWith.call(position.diffrence).format})"
      end
    end
    column :last_sync_at

    actions do |position|
      item 'History', admin_position_position_date_entries_path(position)
    end
  end

  form do |f|
    inputs 'Details' do
      input :asset
      input :account
      input :amount
      input :open_date
      input :open_value, input_html: { value: f.object.open_value.format }
      input :market_value, input_html: { value: f.object.market_value.format }
    end

    actions
  end
end
