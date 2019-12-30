class CarCategoriesController < ApplicationController
  def index
    @car_categories = CarCategory.all
  end

  def show
    @car_category = CarCategory.find(params[:id])
  end

  def new
    @car_category = CarCategory.new
  end

  def edit
    @car_category = CarCategory.find(params[:id])
  end

  def create
    @car_category = CarCategory.new(car_categories_params)
    if @car_category.save
      flash[:notice] = 'Categoria criada com sucesso'
      redirect_to @car_category
    else
      render :new
    end
  end

  def update
    @car_category = CarCategory.find(params[:id])
    if @car_category.update(car_categories_params)
      flash[:notice] = 'Categoria atualizada com sucesso'
      redirect_to @car_category
    else
      render :edit
    end
  end

  def destroy
    @car_category = CarCategory.find(params[:id])
    @car_category.destroy
    redirect_to action: "index" 
  end

  private

  def car_categories_params
    params.require(:car_category).permit(:name, :daily_rate, :car_insurance, :third_party_insurance)
  end
end