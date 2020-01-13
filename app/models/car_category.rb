class CarCategory < ApplicationRecord
  has_many :car_models
  validates :name, presence: { message: 'Nome não pode ficar em branco'}
  validates :daily_rate, presence: { message: 'Taxa Diária não pode ficar em branco'}
  validates :car_insurance, presence: { message: 'Seguro do Carro não pode ficar em branco'}
  validates :third_party_insurance, presence: { message: 'Seguro contra Terceiros não pode ficar em branco'}
end
