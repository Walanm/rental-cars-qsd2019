class Api::V1::CarsController < Api::V1::ApiController
  def index
    @cars = Car.all
    render json: @cars, status: :ok
  end

  def show
    @car = Car.find(params[:id])
    render json: @car, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: '', status: :not_found
  end

  def create
    @car = Car.new(params.permit(:license_plate, :color, :car_model_id, 
                                     :mileage, :subsidiary_id))
    @car.save!
    return render json: @car, status: :created
  rescue ActiveRecord::RecordInvalid
    render json: @car.errors, status: :unprocessable_entity
  end
end