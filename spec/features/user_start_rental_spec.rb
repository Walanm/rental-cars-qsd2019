require 'rails_helper'

feature 'User start rental' do
  scenario 'and view available cars' do
    user = User.create!(email: 'fake@user.com', password: 'fAk3pA55w0rd')
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                    address: 'Rua da Consolação 101')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                       car_insurance: 700.95, third_party_insurance: 200.1)
    other_car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                                             car_insurance: 710.35, third_party_insurance: 150.1)
    client = Client.create!(name: 'Fulano', email: 'fulano@test.com',
                            document: '000.000.000-00')
    Rental.create!(code: 'XFB0000', start_date: Date.current, end_date: 1.day.from_now,
                   client: client, car_category: car_category, user: user)
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                 motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    other_car_model = CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, 
                                       motorization: '1.7', car_category: other_car_category,
                                       fuel_type: 'diesel')
    car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                      subsidiary: subsidiary)
    other_car = Car.create!(license_plate: 'ABC1122', color: 'Vermelho', car_model: other_car_model,
                           mileage: 50, subsidiary: subsidiary)

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
    user = User.create!(email: 'fake@user.com', password: 'fAk3pA55w0rd')
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                    address: 'Rua da Consolação 101')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                       car_insurance: 90.5, third_party_insurance: 100.1)
    client = Client.create!(name: 'Fulano', email: 'fulano@test.com',
                            document: '000.000.000-00')
    Rental.create!(code: 'XFB0000', start_date: Date.current, end_date: 1.day.from_now,
                   client: client, car_category: car_category, user: user)
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                 motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                      subsidiary: subsidiary)


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