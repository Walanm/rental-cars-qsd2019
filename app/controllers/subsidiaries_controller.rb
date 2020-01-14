class SubsidiariesController < ApplicationController
  before_action :set_subsidiary, only: [:show, :edit, :update, :destroy]

  def index
    @subsidiaries = Subsidiary.all
  end

  def show
  end

  def new
    @subsidiary = Subsidiary.new
  end

  def edit
  end

  def create
    @subsidiary = Subsidiary.new(subsidiary_params)

    return render :new unless @subsidiary.save

    flash[:notice] = 'Filial criada com sucesso'
    redirect_to @subsidiary
  end

  def update
    return render :edit unless @subsidiary.update(subsidiary_params)

    flash[:notice] = 'Filial atualizada com sucesso'
    redirect_to @subsidiary
  end

  def destroy
    @subsidiary.destroy
    redirect_to action: "index" 
  end

  private

  def subsidiary_params
    params.require(:subsidiary).permit(:name, :cnpj, :address)
  end

  def set_subsidiary
    @subsidiary = Subsidiary.find(params[:id])
  end
end