class CreateCarRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :car_rentals do |t|
      t.references :car, foreign_key: true
      t.references :rental, foreign_key: true
      t.decimal :daily_rate
      t.decimal :car_insurance
      t.decimal :third_party_insurance
      t.integer :start_mileage
      t.integer :end_mileage

      t.timestamps
    end
  end
end
