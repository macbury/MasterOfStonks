module Stats
  class NetTotalSum < Service
    attr_reader :date

    def initialize(date)
      @date = date
    end

    def call
      PositionDateEntry.includes(:position).where(date: date).sum do |entry|
        ExchangeWith.call(entry.value - entry.position.open_value)
      end
    end
  end
end