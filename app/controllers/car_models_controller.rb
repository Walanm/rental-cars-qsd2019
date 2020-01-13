class CarModelsController < ApplicationController
  def index
    @car_models = CarModel.all
  end

  def show
    @car_model = CarModel.find(params[:id])
  end
  
  def new
    @car_model = CarModel.new
    @manufacturers = Manufacturer.all
    @car_categories = CarCategory.all
  end

  def edit
    @car_model = CarModel.find(params[:id])
    @manufacturers = Manufacturer.all
    @car_categories = CarCategory.all
  end
  
  def create
    @car_model = CarModel.new(car_models_params)
    if @car_model.save
      flash[:notice] = 'Modelo criado com sucesso'
      redirect_to @car_model
    else
      @manufacturers = Manufacturer.all
      @car_categories = CarCategory.all
      render :new
    end
  end

  def update
    @car_model = CarModel.find(params[:id])
    if @car_model.update(car_models_params)
      flash[:notice] = 'Modelo atualizado com sucesso'
      redirect_to @car_model
    else
      @manufacturers = Manufacturer.all
      @car_categories = CarCategory.all
      render :edit
    end
  end

  private

  def car_models_params
    params.require(:car_model).permit(:name, :year, :manufacturer_id, :motorization, :car_category_id, :fuel_type)
  end
end