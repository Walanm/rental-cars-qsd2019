class CarModelsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create edit update]
  before_action :load_manufacturers, only: %i[new edit]
  before_action :load_car_categories, only: %i[new edit]
  before_action :set_car_model, only: %i[show edit update]

  def index
    @car_models = CarModel.all
  end

  def show; end

  def new
    @car_model = CarModel.new
  end

  def edit; end

  def create
    @car_model = CarModel.new(car_model_params)
    if @car_model.save
      flash[:notice] = 'Modelo de carro registrado com sucesso'
      return redirect_to @car_model
    end

    load_manufacturers
    load_car_categories
    render :new
  end

  def update
    if @car_model.update(car_model_params)
      flash[:notice] = 'Modelo de carro atualizado com sucesso'
      return redirect_to @car_model
    end

    load_manufacturers
    load_car_categories
    render :edit
  end

  private

  def car_model_params
    params.require(:car_model).permit(:name, :year, :manufacturer_id,
                                      :motorization, :car_category_id,
                                      :fuel_type)
  end

  def set_car_model
    @car_model = CarModel.find(params[:id])
  end

  def load_manufacturers
    @manufacturers = Manufacturer.all
  end

  def load_car_categories
    @car_categories = CarCategory.all
  end
end
