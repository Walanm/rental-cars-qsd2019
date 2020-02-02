class Api::V1::RentalsController < Api::V1::ApiController
  def create
    @rental = Rental.new(params.permit(:code, :start_date, :end_date, 
                                       :client_id, :car_category_id, :user_id))
    @rental.save!
    return render json: @rental, status: :created
  rescue ActiveRecord::RecordInvalid
     render json: @rental.errors, status: :unprocessable_entity
  end
end