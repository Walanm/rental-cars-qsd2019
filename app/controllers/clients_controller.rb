class ClientsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

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
    @client = Client.new(client_params)

    return render :new unless @client.save

    flash[:notice] = t('.success')
    redirect_to @client
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :document)
  end
end
