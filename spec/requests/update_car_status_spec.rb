require 'rails_helper'

describe 'Update car status API' do
  context '#status' do
    it 'update status to unavailable' do
      subsidiary = create(:subsidiary)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer, 
                                     car_category: car_category)
      car = create(:car, license_plate: 'NVN1010', car_model: car_model,
                         subsidiary: subsidiary, status: :available)

      patch status_api_v1_car_url(id: car, status: 'unavailable')
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:license_plate]).to eq('NVN1010')
      expect(json[:status]).to eq('unavailable')
    end

    it 'update status from unavailable to available' do
      subsidiary = create(:subsidiary)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer, 
                                     car_category: car_category)
      car = create(:car, license_plate: 'NVN1010', car_model: car_model,
                         subsidiary: subsidiary, status: :unavailable)

      patch status_api_v1_car_url(id: car, status: 'available')
      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:license_plate]).to eq('NVN1010')
      expect(json[:status]).to eq('available')
    end

    it 'update to an invalid status' do
      subsidiary = create(:subsidiary)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer, 
                                     car_category: car_category)
      car = create(:car, license_plate: 'NVN1010', car_model: car_model,
                         subsidiary: subsidiary)

      patch status_api_v1_car_url(id: car, status: 'dont care')

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'cannot find car' do
      patch status_api_v1_car_url(id: 'dont care', status: :unavailable)

      expect(response).to have_http_status(:not_found)
    end
  end
end
