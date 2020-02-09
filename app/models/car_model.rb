class CarModel < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :car_category
  has_many :cars, dependent: :restrict_with_exception

  validates :name, presence: { message: 'Nome não pode ficar em branco' }
  validates :year, presence: { message: 'Ano não pode ficar em branco' }
  validates :manufacturer,
            presence: { message: 'Fabricante não pode ficar em branco' }
  validates :motorization,
            presence: { message: 'Motorização não pode ficar em branco' }
  validates :car_category,
            presence: { message: 'Categoria não pode ficar em branco' }
  validates :fuel_type,
            presence: { message: 'Tipo de Combustível não pode ficar em' \
                                 ' branco' }
end
