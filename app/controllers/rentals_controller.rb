class RentalsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
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

    return redirect_to @rental,
      notice: 'Locação registrada com sucesso' if @rental.save

    @clients = Client.all
    @car_categories = CarCategory.all
    render :new
  end

  def search
    @q = params[:q]
    @rentals = Rental.where('UPPER(code) LIKE UPPER(?)', "%#{@q}%")
  end

  private

  def rental_params
    params.require(:rental).permit(:code, :start_date, :end_date, :client_id, :car_category_id, :user_id)
  end
end