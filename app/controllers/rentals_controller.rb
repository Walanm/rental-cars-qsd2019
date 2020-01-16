class RentalsController < ApplicationController
  def index
    @rentals = Rental.all
  end

  def new
    @rental = Rental.new
    @car_categories = CarCategory.all
    @clients = Client.all
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.code = SecureRandom.hex(6)
    @rental.save

    redirect_to rentals_path
  end

  private

  def rental_params
    params.require(:rental).permit(:code, :start_date, :end_date, :client, :car_category)
  end
end