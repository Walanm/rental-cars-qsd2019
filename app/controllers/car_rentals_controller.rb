class CarRentalsController < ApplicationController
  before_action :set_rental, only: %i[new create]
  before_action :set_car, only: [:create]

  def new
    @car_rental = CarRental.new
    @cars = search_available_cars
  end

  def create
    if (@car_rental = @rental.create_car_rental(car: @car,
                                                start_mileage: @car.mileage))
      @rental.in_progress!
      @car.unavailable!
      redirect_to @rental, notice: 'Locação iniciada com sucesso'
    else
      @rental = Rental.find(params[:rental_id])
      @cars = search_available_cars
      render :new
    end
  end

  private

  def search_available_cars
    Car.where(car_model: @rental.car_category.car_models)
       .where(status: :available)
  end

  def set_rental
    @rental = Rental.find(params[:rental_id])
  end

  def set_car
    @car = Car.find(params[:car_id])
  end
end
