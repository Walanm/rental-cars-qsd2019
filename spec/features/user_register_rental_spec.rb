require 'rails_helper'

feature 'User register rental' do
  scenario 'successfully' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    manufacturer = Manufacturer.new(name: 'Fiat')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    car_model = CarModel.new(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                        motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'Registrar locação'
    fill_in 'Data de início', with: '10/01/2040'
    fill_in 'Data de término', with: '15/01/2040'
    select "#{client.document} - #{client.name}", from: 'Cliente'
    select 'A', from: 'Categoria de Carro'
    click_on 'Enviar'

    expect(page).to have_content('Locação registrada com sucesso')
    expect(page).to have_content('10/01/2040')
    expect(page).to have_content('15/01/2040')
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.email)
    expect(page).to have_content(client.document)
    expect(page).to have_content(/A/)
    expect(page).to have_content(user.email)
    expect(Rental.last.code).to match(/[a-zA-Z0-9]+/)
  end

  scenario 'and start date must be greater than today' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'Registrar locação'
    fill_in 'Data de início', with: '10/01/2000'
    fill_in 'Data de término', with: '15/01/2040'
    select "#{client.document} - #{client.name}", from: 'Cliente'
    select 'A', from: 'Categoria de Carro'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Data de início não pode ser no passado')
  end

  scenario 'and end date must be greater than start date' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'Registrar locação'
    fill_in 'Data de início', with: '10/01/2040'
    fill_in 'Data de término', with: '15/01/2020'
    select "#{client.document} - #{client.name}", from: 'Cliente'
    select 'A', from: 'Categoria de Carro'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Data de término deve ser após data de início')
  end

  scenario 'and must have available cars in the period' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'Registrar locação'
    fill_in 'Data de início', with: '10/01/2040'
    fill_in 'Data de término', with: '15/01/2040'
    select "#{client.document} - #{client.name}", from: 'Cliente'
    select 'A', from: 'Categoria de Carro'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Não há carros disponíveis dessa categoria nesse período')
  end

  scenario 'and must be authenticated via routes' do
    visit new_rental_path

    expect(current_path).to eq(new_user_session_path)
  end
end