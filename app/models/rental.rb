class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user

  validate :start_date_greater_than_today, :end_date_greater_than_start_date

  private

  def start_date_greater_than_today
    unless start_date > Date.today
      self.errors[:name] << 'Data de início deve ser após data de hoje'
    end
  end

  def end_date_greater_than_start_date
    unless end_date > start_date
      self.errors[:name] << 'Data de término deve ser após data de início'
    end
  end
end
