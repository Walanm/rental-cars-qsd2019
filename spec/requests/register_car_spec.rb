require 'rails_helper'

describe 'Register car API' do
  context '#create' do
    it 'posts a json successfully' do
      subsidiary = create(:subsidiary)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      post api_v1_cars_url, params: { license_plate: 'ABC1111', color: 'Azul',
                                      car_model_id: car_model.id,
                                      mileage: 95,
                                      subsidiary_id: subsidiary.id }
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
      expect(json[:car_model]).to include('Modelo de carro não pode ficar em' \
                                          ' branco')
      expect(json[:subsidiary]).to include('Filial não pode ficar em branco')
      expect(json[:license_plate]).to include('Placa não pode ficar em branco')
      expect(json[:color]).to include('Cor não pode ficar em branco')
      expect(json[:mileage]).to include('Quilometragem não pode ficar em' \
                                        ' branco')
      expect(json[:mileage]).to include('Quilometragem deve ser maior ou' \
                                        ' igual a zero')
    end
  end
end
