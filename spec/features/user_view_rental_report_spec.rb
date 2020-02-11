require 'rails_helper'

feature 'User view rental report' do
  xscenario 'and choose total rentals by category in a given period' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    client = create(:client)
    manufacturer = build(:manufacturer)
    car_category = create(:car_category, name: 'A')
    car_model = build(:car_model, manufacturer: manufacturer,
                                  car_category: car_category)
    create(:car, car_model: car_model, subsidiary: subsidiary)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'Registrar locação'
    fill_in 'Data de início', with: '10/01/2040'
    fill_in 'Data de término', with: '15/01/2040'
    select "#{client.document} - #{client.name}", from: 'Cliente'
    select 'A', from: 'Categoria de Carro'
    click_on 'Enviar'

    
  end

  xscenario 'and get no results for rentals by category in a given period' do

  end

  xscenario 'and choose total rentals by subsidiary in a given period' do

  end

  xscenario 'and get no results for rentals by subsidiary in a given period' do

  end

  xscenario 'and choose total rentals by car model in a given period' do

  end

  xscenario 'and get no results for rentals by car model in a given period' do

  end
end