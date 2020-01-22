class Car < ApplicationRecord
  belongs_to :car_model
  belongs_to :subsidiary

  validates :license_plate, presence: { message: 'Placa não pode ficar em branco'},
                            uniqueness: { message: 'Placa deve ser única'}
  validates :color, presence: { message: 'Cor não pode ficar em branco'}
  validates :car_model, presence: { message: 'Modelo de carro não pode ficar em branco'}
  validates :mileage, presence: { message: 'Quilometragem não pode ficar em branco'},
    numericality: { greater_than_or_equal_to: 0, message: 'Quilometragem deve ser maior ou igual a zero' }
  validates :subsidiary, presence: { message: 'Filial não pode ficar em branco'}

  enum status: { available: 0, unavailable: 1 }

  def full_description
    return 'Carro não cadastrado corretamente' if car_model.nil?
    "#{car_model.manufacturer.name} #{car_model.name} - #{color} - #{license_plate}"
  end
end
