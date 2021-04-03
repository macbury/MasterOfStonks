module Stats
  class WalletComposition < Service
    def initialize(date: Time.zone.today)
      @date = date
    end

    def call
      percentages = {}
      amounts = []
      sums.each do |category_name, amount|
        percentage = ((amount / total_sum) * 100).round
        percentages["#{category_name} (#{percentage}%)"] = percentage
        amounts << {
          name: category_name,
          percentage: percentage,
          amount: amount
        }
      end

      amounts.sort_by! { |a| a[:name] }
      return [percentages, amounts]
    end

    private

    attr_reader :date

    def stats_for(category)
      PositionDateEntry
        .joins(position: { asset: :category })
        .where(position_id: Position.opened.pluck(:id))
        .where(date: date, position: { assets: { category_id: category.id } })
        .map(&:exchange_value)
        .sum
    end

    def sums
      @sums ||= Category.all.each_with_object({}) do |category, sums|
        sums[category.name] = stats_for(category) || 0.to_money
      end
    end

    def total_sum
      @total_sum ||= sums.values.sum
    end
  end
end