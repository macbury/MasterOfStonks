class Position < ApplicationRecord
  belongs_to :asset
  belongs_to :account, optional: true

  has_many :position_date_entries, dependent: :destroy

  enum state: %i[opened closed archived]

  monetize :open_value_cents
  monetize :market_value_cents

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hash_id, presence: true, uniqueness: { scope: [:asset_id] }

  scope :opened, -> { where('last_sync_at >= ?', Time.zone.today) }
  scope :closed, -> { where('last_sync_at < ?', Time.zone.today) }

  def diffrence
    market_value - open_value
  end
end
