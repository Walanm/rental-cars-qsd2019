class Manufacturer < ApplicationRecord
  has_many :car_models, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
