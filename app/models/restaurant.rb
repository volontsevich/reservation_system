class Restaurant < ApplicationRecord
  has_many :tables

  validates :name, presence: true, uniqueness: true

  TABLES_PER_RESTAURANT = 5
end
