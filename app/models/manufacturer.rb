class Manufacturer < ApplicationRecord
  has_many :car_models, dependent: :restrict_with_exception

  validates :name, presence: { message: 'Nome não pode ficar em branco' },
                   uniqueness: { message: 'Nome deve ser único' }
end
