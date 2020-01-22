class CarRental < ApplicationRecord
  belongs_to :car
  belongs_to :rental

  def daily_price
    daily_rate + car_insurance + third_party_insurance
  end
end
