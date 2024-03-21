class Reservation < ApplicationRecord
  STANDARD_BOOKING_TIME = 1.hour.in_seconds
  BOOKING_FREQUENCY = 15.minutes

  belongs_to :table

  validates :party_size, :start_time, :end_time, presence: true
  validate :end_time_after_start_time?

  def end_time_after_start_time?
    errors.add(:end_time, 'must be after Start time') if start_time.present? && end_time.present? && end_time < start_time
  end

end
