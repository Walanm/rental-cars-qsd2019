require 'rails_helper'

describe 'Register Rental API' do
  context '#create' do
    it 'posts a json successfully' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      client = create(:client)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer, 
                                     car_category: car_category)
      car = create(:car, car_model: car_model, subsidiary: subsidiary)
      
      post api_v1_rentals_url, params: { code: 'XFB000', start_date: Date.current,
                                         end_date: 1.day.from_now, 
                                         client_id: client.id, 
                                         car_category_id: car_category.id, 
                                         user_id: user.id }
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
      expect(json[:start_date]).to include('Data de Início não pode ficar em branco')
      expect(json[:end_date]).to include('Data de Término não pode ficar em branco')
      expect(json[:client]).to include('é obrigatório(a)')
      expect(json[:car_category]).to include('é obrigatório(a)')
      expect(json[:user]).to include('é obrigatório(a)')
    end
  end
end