class Client < ApplicationRecord
  has_many :rentals, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :email, presence: true
  validates :document, presence: true

  def identification
    "#{document} - #{name}"
  end
end
