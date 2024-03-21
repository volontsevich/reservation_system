class ChangeReservationStructure < ActiveRecord::Migration[6.1]
  def change
    remove_column :reservations, :duration, :integer
    add_column :reservations, :end_time, :datetime
  end
end
