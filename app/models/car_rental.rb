class CarRental < ApplicationRecord
  belongs_to :car
  belongs_to :rental

  before_validation :register_current_costs, on: :create

  validates :daily_rate, presence: true
  validates :car_insurance, presence: true
  validates :third_party_insurance, presence: true
  validates :start_mileage, presence: true

  def daily_price
    daily_rate + car_insurance + third_party_insurance
  end

  def register_current_costs
    return unless rental.present? && rental.car_category.present?

    self.daily_rate = rental.car_category.daily_rate
    self.car_insurance = rental.car_category.car_insurance
    self.third_party_insurance = rental.car_category.third_party_insurance
  end
end
