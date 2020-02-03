require 'rails_helper'

describe 'Update car status API' do
  context '#status' do
    it 'update status to unavailable' do
      subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                         car_insurance: 90.5, third_party_insurance: 100.1)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                   motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Prata', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)

      patch status_api_v1_car_url(id: car, status: 'unavailable')
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:license_plate]).to eq('NVN1010')
      expect(json[:status]).to eq('unavailable')
    end

    it 'update status from unavailable to available' do
      subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                         car_insurance: 90.5, third_party_insurance: 100.1)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                   motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Prata', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary, status: :unavailable)

      patch status_api_v1_car_url(id: car, status: 'available')
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:license_plate]).to eq('NVN1010')
      expect(json[:status]).to eq('available')
    end

    it 'update to an invalid status' do
      subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                         car_insurance: 90.5, third_party_insurance: 100.1)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                   motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Prata', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary, status: :available)

      patch status_api_v1_car_url(id: car, status: 'dont care')

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'cannot find car' do
      subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                         car_insurance: 90.5, third_party_insurance: 100.1)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                   motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Prata', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary, status: :available)

      patch status_api_v1_car_url(id: 'dont care', status: :unavailable)

      expect(response).to have_http_status(:not_found)
    end
  end
end
