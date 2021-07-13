module Stats
  class NetSumChart < Service
    def initialize(from: 1.month.ago, to: Time.zone.today)
      @from = from.to_date
      @to = to.to_date
    end

    def call(&block)
      @dates = (from..to).each_with_object({}) { |date, dates| dates[block&.call(date) || date] = 0.to_money }

      PositionDateEntry.includes(:position).where('date >= :from AND date <= :to', from: from, to: to).find_each do |entry|
        date = block_given? ? yield(entry.date.to_date) : entry.date.to_date

        Rails.logger.info "Entry for: #{date}"
        @dates[date] += ExchangeWith.call(entry.value - entry.position.open_value)
      end

      @dates.each_with_object({}) do |(date, amount), result|
        result[date] = amount.to_f
      end
    end

    private

    attr_reader :from, :to
  end
end