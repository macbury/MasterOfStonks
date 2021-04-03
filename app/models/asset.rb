class Asset < ApplicationRecord
  has_many :positions, dependent: :destroy
  belongs_to :category, optional: true

  enum source: {
    investing: 'investing',
    bonds: 'bonds'
  }

  validates :name, presence: true
  validates :symbol, presence: true, uniqueness: true
  validates :source, presence: true

  after_save :update_positions

  def update_positions
    positions.update_all(
      open_value_currency: currency,
      market_value_currency: currency
    )

    PositionDateEntry.where(position_id: positions.pluck(:id)).update_all(
      value_currency: currency
    )
  end

  def cast_to_money(cents)
    if sterling
      Money.pound_sterling(cents)
    else
      cents.to_money(currency)
    end
  end
end
