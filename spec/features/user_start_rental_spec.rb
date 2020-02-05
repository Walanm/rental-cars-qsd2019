require 'rails_helper'

feature 'User start rental' do
  scenario 'and view available cars' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    car_category = create(:car_category, name: 'A')
    other_car_category = create(:car_category, name: 'B')
    client = create(:client)
    manufacturer = create(:manufacturer, name: 'Fiat')
    car_model = create(:car_model, name: 'Mobi', manufacturer: manufacturer,
                                   car_category: car_category)
    other_car_model = create(:car_model, name: 'Uno', 
                                         manufacturer: manufacturer,
                                         car_category: other_car_category)
    car = create(:car, license_plate: 'NVN1010', color: 'Azul',
                       car_model: car_model, subsidiary: subsidiary)
    other_car = create(:car, license_plate: 'ABC1122', color: 'Vermelho', 
                             car_model: other_car_model,
                             subsidiary: subsidiary)
    create(:rental, code: 'XFB0000', client: client,
                    car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'XFB000'
    click_on 'Buscar'
    click_on 'Efetivar Locação'

    expect(page).to have_content('Efetivar Locação - XFB000')
    expect(page).to have_content('Fiat Mobi - Azul - NVN1010')
    expect(page).not_to have_content('Fiat Uno - Vermelho - ABC1122')
  end

  scenario 'and start successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    car_category = create(:car_category, daily_rate: 19.5,
                                         car_insurance: 90.5, 
                                         third_party_insurance: 100.1)
    client = create(:client)
    manufacturer = create(:manufacturer, name: 'Fiat')
    car_model = create(:car_model, name: 'Mobi', manufacturer: manufacturer,
                                   car_category: car_category)
    car = create(:car, license_plate: 'NVN1010', color: 'Azul',
                       car_model: car_model, subsidiary: subsidiary)
    create(:rental, code: 'XFB0000', client: client,
                    car_category: car_category, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'XFB0000'
    click_on 'Buscar'
    click_on 'Efetivar Locação'
    within("div#car-#{car.id}") do
      click_on 'Iniciar'
    end

    expect(page).to have_content('Locação iniciada com sucesso')
    expect(page).to have_content('Em andamento')
    expect(page).to have_content('Fiat Mobi - Azul - NVN1010')
    expect(page).to have_content('Diária: R$210.10')
  end
end