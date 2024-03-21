class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :tables do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.integer :number
      t.integer :seats_amount

      t.timestamps
    end
  end
end
