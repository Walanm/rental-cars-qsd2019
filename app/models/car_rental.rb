class CarRental < ApplicationRecord
  belongs_to :car
  belongs_to :rental

  before_validation :register_current_costs

  validates :daily_rate,
            presence: { message: 'Taxa Diária não pode ficar em branco' }
  validates :car_insurance,
            presence: { message: 'Seguro do Carro não pode ficar em branco' }
  validates :third_party_insurance,
            presence: { message: 'Seguro contra Terceiros não pode' \
                                 ' ficar em branco' }
  validates :start_mileage,
            presence: { message: 'Quilometragem Inicial não pode' \
                                 ' ficar em branco' }

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
