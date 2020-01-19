class RentalsController < ApplicationController
  def index
    @rentals = Rental.all
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def new
    @car_categories = CarCategory.all
    @clients = Client.all
    @rental = Rental.new
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.code = SecureRandom.hex(6)
    @rental.user = current_user
    @rental.save

    flash[:notice] = 'Locação registrada com sucesso'

    redirect_to @rental
  end

  private

  def rental_params
    params.require(:rental).permit(:code, :start_date, :end_date, :client_id, :car_category_id)
  end
end