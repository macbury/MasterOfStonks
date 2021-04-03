class Account < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :positions, dependent: :destroy
end
