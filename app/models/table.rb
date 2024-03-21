class Table < ApplicationRecord
  MIN_SEATS_AMOUNT = 2
  MAX_SEATS_AMOUNT = 5

  belongs_to :restaurant
  has_many :reservations

  validates :number, :seats_amount, presence: true
  validates_uniqueness_of :number, scope: :restaurant_id
end
