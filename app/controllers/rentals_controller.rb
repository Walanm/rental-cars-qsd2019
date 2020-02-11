class RentalsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  def index
    @rentals = Rental.all
  end

  def show
    @rental = Rental.find(params[:id])
    @car_rental = CarRental.find_by(rental: @rental.id) if @rental.in_progress?
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
    return redirect_to @rental, notice: t('.success') if @rental.save

    @clients = Client.all
    @car_categories = CarCategory.all
    render :new
  end

  def cancel
    @rental = Rental.find(params[:id])
  end

  def finish_cancel
    @rental = Rental.find(params[:id])
    @rental.status = :cancelled
    return render :cancel unless @rental.update(rental_cancellation_params)
                                    
    redirect_to rental_path(@rental), notice: t('.success')                                
  end

  def search
    @q = params[:q]
    @rentals = Rental.where('UPPER(code) LIKE UPPER(?)', "%#{@q}%")

    redirect_to @rentals[0] if @rentals.size == 1
  end

  private

  def rental_params
    params.require(:rental).permit(:code, :start_date, :end_date, :client_id,
                                   :car_category_id, :user_id)
  end

  def rental_cancellation_params
    params.require(:rental).permit(:cancellation_reason)
  end
end
