class CarsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
    @car_models = CarModel.all
    @subsidiaries = Subsidiary.all
  end

  def create
    @car = Car.new(car_params)

    if @car.save
      flash[:notice] = t('.success')
      return redirect_to @car
    end

    @car_models = CarModel.all
    @subsidiaries = Subsidiary.all
    render :new
  end

  private

  def car_params
    params.require(:car).permit(:license_plate, :color, :car_model_id,
                                :mileage, :subsidiary_id)
  end
end
