require 'rails_helper'

describe 'Receive car details API' do
  context '#create' do
    it 'posts a json successfully' do
      subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                  address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                         car_insurance: 90.5, third_party_insurance: 100.1)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                   motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      
      post api_v1_cars_url, params: { license_plate: 'ABC1111', color: 'Azul', car_model_id: car_model.id, 
                                      mileage: 95, subsidiary_id: subsidiary.id }
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:created)
      expect(json[:license_plate]).to eq('ABC1111')
      expect(json[:color]).to eq('Azul')
      expect(json[:car_model_id]).to eq(car_model.id)
      expect(json[:mileage]).to eq(95)
      expect(json[:subsidiary_id]).to eq(subsidiary.id)
    end

    it 'posts an empty json' do
      post api_v1_cars_url
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json[:car_model]).to include('Modelo de carro não pode ficar em branco')
      expect(json[:subsidiary]).to include('Filial não pode ficar em branco')
      expect(json[:license_plate]).to include('Placa não pode ficar em branco')
      expect(json[:color]).to include('Cor não pode ficar em branco')
      expect(json[:mileage]).to include('Quilometragem não pode ficar em branco')
      expect(json[:mileage]).to include('Quilometragem deve ser maior ou igual a zero')
    end
  end
end