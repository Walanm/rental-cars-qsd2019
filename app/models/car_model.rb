class CarModel < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :car_category
  has_many :cars, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :year, presence: true
  validates :manufacturer, presence: true
  validates :motorization, presence: true
  validates :car_category, presence: true
  validates :fuel_type, presence: true
end
