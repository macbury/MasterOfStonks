class Category < ApplicationRecord
  has_many :assets, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
