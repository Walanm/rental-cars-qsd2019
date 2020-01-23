class CarRentalsController < ApplicationController
  def new
    @car_rental = CarRental.new
    @rental = Rental.find(params[:rental_id])
    @cars = Car.where(car_model: @rental.car_category.car_models)
               .where(status: :available)
  end

  def create
    @rental = Rental.find(params[:rental_id])
    @car = Car.find(params[:car_id])
    @car_rental = @rental.create_car_rental(car: @car, start_mileage: @car.mileage)
    @rental.in_progress!
    @car.unavailable!
    redirect_to @rental, notice: 'Locação iniciada com sucesso'
  end

end