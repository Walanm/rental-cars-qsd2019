class Rental < ApplicationRecord
  belongs_to :client
  belongs_to :car_category
  belongs_to :user
  has_one :car_rental, dependent: :restrict_with_exception
  has_one :subsidiary, through: :user

  validates :start_date,
            presence: { message: 'Data de Início não pode ficar em branco' }
  validates :end_date,
            presence: { message: 'Data de Término não pode ficar em branco' }

  validate :start_date_cannot_be_in_the_past,
           :end_date_greater_than_start_date,
           :available_cars?

  enum status: { scheduled: 0, in_progress: 4 }

  private

  def start_date_cannot_be_in_the_past
    return unless start_date.present? && start_date < Date.current

    errors[:start_date] << 'Data de início não pode ser no passado'
  end

  def end_date_greater_than_start_date
    return unless start_date.present? &&
                  end_date.present? && end_date < start_date

    errors[:end_date] << 'Data de término deve ser após data de início'
  end

  def available_cars?
    return if car_category.blank?

    @cars = Car.where(car_model: car_category.car_models,
                      subsidiary: subsidiary.id)
    @total_rentals = same_category_local_rentals +
                     same_category_long_period_local_rentals
    return if @cars.count > @total_rentals

    errors[:base] << 'Não há carros disponíveis dessa categoria' \
                     ' nesse período'
  end

  def same_category_local_rentals
    Rental.where.not(id: id)
          .where(car_category: car_category,
                 subsidiary: user.subsidiary.id)
          .where('start_date BETWEEN :start AND :end
                  OR end_date BETWEEN :start AND :end',
                 start: start_date, end: end_date)
          .count
  end

  def same_category_long_period_local_rentals
    Rental.where.not(id: id)
          .where(car_category: car_category,
                 subsidiary: user.subsidiary.id)
          .where('start_date < ? AND end_date > ?',
                 start_date, end_date)
          .count
  end
end
