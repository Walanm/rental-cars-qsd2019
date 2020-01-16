class CarCategory < ApplicationRecord
  has_many :car_models
  has_many :rentals

  validates :name, presence: { message: 'Nome não pode ficar em branco'}
  validates :daily_rate, presence: { message: 'Taxa Diária não pode ficar em branco'},
    numericality: { greater_than: 0, message: 'Taxa Diária deve ser maior que zero' }

  validates :car_insurance, presence: { message: 'Seguro do Carro não pode ficar em branco'},
    numericality: { greater_than: 0,  message: 'Seguro do Carro deve ser maior que zero' }
                              
  validates :third_party_insurance, presence: { message: 'Seguro contra Terceiros não pode ficar em branco'},
    numericality: { greater_than: 0, message: 'Seguro contra Terceiros deve ser maior que zero' }
end
