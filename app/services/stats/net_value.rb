module Stats
  class NetValue < Service
    def initialize(from: 1.month.ago, to: Time.zone.today)
      @from = from.to_date
      @to = to.to_date
    end

    def call
      @dates = (from..to).each_with_object({}) { |date, dates| dates[date] = 0.to_money }

      PositionDateEntry.where('date >= :from AND date <= :to', from: from, to: to).find_each do |entry|
        @dates[entry.date.to_date] += entry.exchange_value
      end

      @dates.each_with_object({}) do |(date, amount), result|
        result[date] = amount.to_f
      end
    end

    private

    attr_reader :from, :to

    def stats_for(category)
      PositionDateEntry
        .joins(position: { asset: :category })
        .where(date: date, position: { assets: { category_id: category.id } })
        .map(&:exchange_value)
        .sum
    end

    def sums
      @sums ||= Category.all.each_with_object({}) do |category, sums|
        sums[category.name] = stats_for(category)
      end
    end

    def total_sum
      @total_sum ||= sums.values.sum
    end
  end
end