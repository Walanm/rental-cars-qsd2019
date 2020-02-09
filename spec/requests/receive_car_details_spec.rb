require 'rails_helper'

describe 'Receive car details API' do
  context '#show' do
    it 'renders a json successfully' do
      subsidiary = Subsidiary.new(name: 'Alamo')
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      car = create(:car, car_model: car_model, subsidiary: subsidiary)

      get api_v1_car_path(car)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:license_plate]).to eq(car.license_plate)
      expect(json[:color]).to eq(car.color)
      expect(json[:car_model_id]).to eq(car.car_model_id)
      expect(json[:mileage]).to eq(car.mileage)
      expect(json[:subsidiary_id]).to eq(car.subsidiary_id)
    end

    it 'cannot find object' do
      get api_v1_car_path(id: 999)

      expect(response).to have_http_status(:not_found)
    end
  end

  context '#index' do
    it 'renders a json successfully' do
      subsidiary = Subsidiary.new(name: 'Alamo')
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      car = Car.create!(license_plate: 'NVN1010', color: 'Prata',
                        car_model: car_model, mileage: 127,
                        subsidiary: subsidiary)
      other_car = Car.create!(license_plate: 'ABC1111', color: 'Azul',
                              car_model: car_model, mileage: 95,
                              subsidiary: subsidiary)

      get api_v1_cars_path
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json.length).to eq(2)
      expect(json[0][:license_plate]).to eq(car.license_plate)
      expect(json[0][:color]).to eq(car.color)
      expect(json[0][:car_model_id]).to eq(car.car_model_id)
      expect(json[0][:mileage]).to eq(car.mileage)
      expect(json[0][:subsidiary_id]).to eq(car.subsidiary_id)
      expect(json[1][:license_plate]).to eq(other_car.license_plate)
      expect(json[1][:color]).to eq(other_car.color)
      expect(json[1][:car_model_id]).to eq(other_car.car_model_id)
      expect(json[1][:mileage]).to eq(other_car.mileage)
      expect(json[1][:subsidiary_id]).to eq(other_car.subsidiary_id)
    end

    it 'doesnt have any car' do
      get api_v1_cars_path
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json).to eq([])
    end
  end
end
