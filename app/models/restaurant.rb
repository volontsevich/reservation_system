class Restaurant < ApplicationRecord
  START_OF_WORKING_HOURS = 10 # restaurant opens at 10am
  END_OF_WORKING_HOURS = 22 # restaurant works till 10pm
  TABLES_PER_RESTAURANT = 5

  has_many :tables

  validates :name, presence: true, uniqueness: true
end
