require 'rails_helper'

describe 'Register Rental API' do
  context '#create' do
    it 'posts a json successfully' do
      subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
      user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)
      client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
      manufacturer = Manufacturer.new(name: 'Peugeot')
      car_category =CarCategory.create!(name: 'A', daily_rate: 19.5,
                          car_insurance: 700.95, third_party_insurance: 200.1)
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                   motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      
      post api_v1_rentals_url, params: { code: 'XFB000', start_date: Date.current, end_date: 1.day.from_now, 
                                         client_id: client.id, car_category_id: car_category.id, user_id: user.id }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:code]).to eq('XFB000')
      expect(json[:start_date]).to eq(Date.current.strftime('%Y-%m-%d'))
      expect(json[:end_date]).to eq(1.day.from_now.strftime('%Y-%m-%d'))
      expect(json[:client_id]).to eq(client.id)
      expect(json[:car_category_id]).to eq(car_category.id)
      expect(json[:user_id]).to eq(user.id)
    end

    it 'posts an empty json' do
      post api_v1_rentals_url
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:start_date]).to include("Data de Início não pode ficar em branco")
      expect(json[:end_date]).to include("Data de Término não pode ficar em branco")
      expect(json[:client]).to include("must exist")
      expect(json[:car_category]).to include("must exist")
      expect(json[:user]).to include("must exist")
    end
  end
end