class Car < ApplicationRecord
  belongs_to :car_model
  belongs_to :subsidiary

  validates :license_plate, presence: true, uniqueness: true
  validates :color, presence: true
  validates :car_model, presence: true
  validates :mileage, presence: true,
                      numericality: { greater_than_or_equal_to: 0 }
  validates :subsidiary, presence: true

  enum status: { available: 0, unavailable: 4 }

  def full_description
    return 'Carro não cadastrado corretamente' if car_model.nil?

    "#{car_model.manufacturer.name} #{car_model.name} - #{color} -" \
    " #{license_plate}"
  end
end
