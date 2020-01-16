class Client < ApplicationRecord
  has_many :rentals

  validates :name, presence: { message: 'Nome não pode ficar em branco'}
  validates :email, presence: { message: 'Email não pode ficar em branco'}
  validates :document, presence: { message: 'CPF não pode ficar em branco'}

  def identification
    "#{document} - #{name}"
  end
end