class Subsidiary < ApplicationRecord
  has_many :cars, dependent: :restrict_with_exception

  validates :name, uniqueness: true
  validates_cnpj_format_of :cnpj
end
