class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user
  has_one :car_rental

  validates :start_date, presence: { message: 'Data de Início não pode ficar em branco'}
  validates :end_date, presence: { message: 'Data de Término não pode ficar em branco'}

  validate :start_date_cannot_be_in_the_past, :end_date_greater_than_start_date, 
           :have_available_cars

  enum status: { scheduled: 0, in_progress: 4 }

  private

  def start_date_cannot_be_in_the_past
    if start_date.present? && start_date < Date.today
      self.errors[:start_date] << 'Data de início não pode ser no passado'
    end
  end

  def end_date_greater_than_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      self.errors[:end_date] << 'Data de término deve ser após data de início'
    end
  end

  def have_available_cars
    if car_category.present?
      @rentals = Rental.where.not(id: id).where(car_category: car_category)
                       .where('start_date BETWEEN :start AND :end 
                               OR end_date BETWEEN :start AND :end', 
                               start: start_date, end: end_date)
      @long_period_rentals = Rental.where(car_category: car_category)
                                  .where('start_date < ? AND end_date > ?',
                                  start_date, end_date)
      @cars = Car.where(car_model: car_category.car_models)
      
      unless @cars.count > (@rentals.count + @long_period_rentals.count)
        self.errors[:base] << 'Não há carros disponíveis dessa categoria nesse período'
      end
    end
  end
end
