class Subsidiary < ApplicationRecord
  has_many :cars, dependent: :restrict_with_exception

  validates :name, uniqueness: { message: 'Nome deve ser único' }
  validates_cnpj_format_of :cnpj, message: 'CNPJ deve ser válido'
end
