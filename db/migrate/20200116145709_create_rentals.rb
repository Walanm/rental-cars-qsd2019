class CreateRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.references :client, foreign_key: true
      t.references :car_category, foreign_key: true

      t.timestamps
    end
  end
end
