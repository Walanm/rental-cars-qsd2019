require 'rails_helper'

feature 'Admin register car' do
  scenario 'successfully' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer,
                     motorization: '1.7', car_category: car_category, fuel_type: 'diesel')
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    
    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    fill_in 'Placa', with: 'NVN1010'
    fill_in 'Cor', with: 'Azul'
    select 'Uno', from: 'Modelo de Carro'
    fill_in 'Quilometragem', with: '50'
    select 'Alamo', from: 'Filial'
    click_on 'Enviar'

    expect(page).to have_content('Carro registrado com sucesso')
    expect(page).to have_content('NVN1010')
    expect(page).to have_content('Azul')
    expect(page).to have_content('Uno')
    expect(page).to have_content('50 km')
    expect(page).to have_content('Alamo')
  end

  scenario 'and must fill all fields' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    
    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Placa não pode ficar em branco')
    expect(page).to have_content('Cor não pode ficar em branco')
    expect(page).to have_content('Modelo de carro não pode ficar em branco')
    expect(page).to have_content('Quilometragem não pode ficar em branco')
    expect(page).to have_content('Filial não pode ficar em branco')
  end

  scenario 'and license plate must be unique' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    car_model = CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer,
                                 motorization: '1.7', car_category: car_category, fuel_type: 'diesel')
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    Car.create!(license_plate: 'NVN1010', color: 'Vermelho', car_model: car_model, 
                mileage: 60, subsidiary: subsidiary)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    fill_in 'Placa', with: 'NVN1010'
    fill_in 'Cor', with: 'Azul'
    select 'Uno', from: 'Modelo de Carro'
    fill_in 'Quilometragem', with: '50'
    select 'Alamo', from: 'Filial'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Placa deve ser única')
  end

  scenario 'mileage must be equal or greater than zero' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer,
                     motorization: '1.7', car_category: car_category, fuel_type: 'diesel')
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    
    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    fill_in 'Placa', with: 'NVN1010'
    fill_in 'Cor', with: 'Azul'
    select 'Uno', from: 'Modelo de Carro'
    fill_in 'Quilometragem', with: '-10'
    select 'Alamo', from: 'Filial'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Quilometragem deve ser maior ou igual a zero')
  end

  scenario 'and must be authenticated via routes' do
    visit new_car_path

    expect(current_path).to eq(new_user_session_path)
  end
end