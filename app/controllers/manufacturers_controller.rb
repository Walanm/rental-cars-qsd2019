class ManufacturersController < ApplicationController
  before_action :authenticate_user!, only: %i[index show new create edit update]
  before_action :set_manufacturer, only: %i[show edit update]

  def index
    @manufacturers = Manufacturer.all
  end

  def show; end

  def new
    @manufacturer = Manufacturer.new
  end

  def edit; end

  def create
    @manufacturer = Manufacturer.new(manufacturer_params)

    return render :new unless @manufacturer.save

    flash[:notice] = 'Fabricante criada com sucesso'
    redirect_to @manufacturer
  end

  def update
    return render :edit unless @manufacturer.update(manufacturer_params)

    flash[:notice] = 'Fabricante atualizada com sucesso'
    redirect_to @manufacturer
  end

  private

  def manufacturer_params
    params.require(:manufacturer).permit(:name)
  end

  def set_manufacturer
    @manufacturer = Manufacturer.find(params[:id])
  end
end
