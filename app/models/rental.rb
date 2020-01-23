class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user
  has_one :car_rental

  validate :start_date_cannot_be_in_the_past, :end_date_greater_than_start_date

  enum status: { scheduled: 0, in_progress: 4 }

  private

  def start_date_cannot_be_in_the_past
    unless start_date >= Date.today
      self.errors[:name] << 'Data de início deve ser após data de hoje'
    end
  end

  def end_date_greater_than_start_date
    unless end_date > start_date
      self.errors[:name] << 'Data de término deve ser após data de início'
    end
  end

  def have_available_cars
    
  end
end
