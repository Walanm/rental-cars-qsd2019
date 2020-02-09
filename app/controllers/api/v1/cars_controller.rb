module Api
  module V1
    class CarsController < Api::V1::ApiController
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
        render json: @car, status: :created
      rescue ActiveRecord::RecordInvalid
        render json: @car.errors, status: :unprocessable_entity
      end

      def status
        @car = Car.find(params[:id])
        @car.update!(status: params[:status])
        render json: @car.to_json(only: %i[license_plate status]), status: :ok
      rescue ArgumentError
        render json: '', status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound
        render json: '', status: :not_found
      end
    end
  end
end
