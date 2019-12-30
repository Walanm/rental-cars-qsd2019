class SubsidiariesController < ApplicationController
  def index
    @subsidiaries = Subsidiary.all
  end

  def show
    @subsidiary = Subsidiary.find(params[:id])
  end

  def new
    @subsidiary = Subsidiary.new
  end

  def edit
    @subsidiary = Subsidiary.find(params[:id])
  end

  def create
    @subsidiary = Subsidiary.new(subsidiary_params)
    if @subsidiary.save
      flash[:notice] = 'Filial criada com sucesso'
      redirect_to @subsidiary
    else
      render :new
    end
  end

  def update
    @subsidiary = Subsidiary.find(params[:id])
    if @subsidiary.update(subsidiary_params)
      flash[:notice] = 'Filial atualizada com sucesso'
      redirect_to @subsidiary
    else
      render :edit
    end
  end

  def destroy
    @subsidiary = Subsidiary.find(params[:id])
    @subsidiary.destroy
    redirect_to action: "index" 
  end

  private

  def subsidiary_params
    params.require(:subsidiary).permit(:name, :cnpj, :address)
  end
end