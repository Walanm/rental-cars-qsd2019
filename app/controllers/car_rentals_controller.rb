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
    @car_rental = CarRental.new(car: @car, rental: @rental)
    @rental.in_progress!
    @car_rental.daily_rate = @rental.car_category.daily_rate
    @car_rental.car_insurance = @rental.car_category.car_insurance
    @car_rental.third_party_insurance = @rental.car_category.third_party_insurance
    @car_rental.save
    redirect_to @rental, notice: 'Locação iniciada com sucesso'
  end

end