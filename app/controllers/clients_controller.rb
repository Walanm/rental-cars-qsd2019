class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def show
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params.require(:client).permit(:name, :email, :document))
    @client.save
    flash[:notice] = 'Cliente registrado com sucesso'
    redirect_to @client
  end
end