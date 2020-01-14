class CarCategoriesController < ApplicationController
  before_action :set_car_category, only: [:show, :edit, :update, :destroy]
  
  def index
    @car_categories = CarCategory.all
  end

  def show
  end

  def new
    @car_category = CarCategory.new
  end

  def edit
  end

  def create
    @car_category = CarCategory.new(car_categories_params)
    
    return render :new unless @car_category.save

    flash[:notice] = 'Categoria criada com sucesso'
    redirect_to @car_category
  end

  def update
    return render :edit unless @car_category.update(car_categories_params)

    flash[:notice] = 'Categoria atualizada com sucesso'
    redirect_to @car_category
  end

  def destroy
    @car_category.destroy
    redirect_to action: "index" 
  end

  private

  def car_categories_params
    params.require(:car_category).permit(:name, :daily_rate, :car_insurance, :third_party_insurance)
  end

  def set_car_category
    @car_category = CarCategory.find(params[:id])
  end
end