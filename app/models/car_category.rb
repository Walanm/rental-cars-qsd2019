class CarCategory < ApplicationRecord
  has_many :car_models, dependent: :restrict_with_exception
  has_many :rentals, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :daily_rate, presence: true, numericality: { greater_than: 0 }
  validates :car_insurance, presence: true, numericality: { greater_than: 0 }
  validates :third_party_insurance, presence: true,
                                    numericality: { greater_than: 0 }
end
