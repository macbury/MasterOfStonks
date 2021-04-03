module Holdings
  class Create < Service
    def initialize(name:, symbol:, source:, amount:, open_value:, market_value:, hash_id:, open_date: nil)
      @name = name.strip
      @symbol = symbol.strip
      @source = source.strip.to_sym
      @amount = amount.to_f
      @open_value = open_value
      @market_value = market_value
      @hash_id = hash_id.strip
      @date = Time.zone.today
      @open_date = (open_date || @date).to_date
    end

    def call
      Asset.transaction do
        @position = create_current_position!
        create_date_entry(@position)
      end
    end

    private

    attr_reader :name, :symbol, :amount, :open_value, :market_value, :hash_id, :open_date, :source, :position, :date

    def asset
      @asset ||= Asset.find_or_initialize_by(symbol: symbol).tap do |asset|
        asset.name = name
        asset.source = source
        asset.save!
      end
    end

    def create_current_position!
      position = asset.positions.find_or_initialize_by(hash_id: hash_id)
      position.amount = amount
      position.open_date = open_date
      position.open_value = asset.cast_to_money(open_value)
      position.market_value = asset.cast_to_money(market_value)
      position.last_sync_at = Time.zone.now
      position.save!
      position
    end

    def create_date_entry(position)
      position.position_date_entries.find_or_initialize_by(date: date).tap do |entry|
        entry.amount = position.amount
        entry.value = position.market_value
        entry.exchange_value = ExchangeWith.call(position.market_value)
        entry.save!
      end
    end
  end
end