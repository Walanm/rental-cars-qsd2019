class User < ApplicationRecord
  has_many :rentals, dependent: :restrict_with_exception
  belongs_to :subsidiary

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
