class PositionDateEntry < ApplicationRecord
  belongs_to :position

  validates :date, presence: true, uniqueness: { scope: [:position_id] }

  monetize :value_cents
  monetize :exchange_value_cents
end
