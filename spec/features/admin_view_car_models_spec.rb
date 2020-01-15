require 'rails_helper'

feature 'Admin view car models' do
  scenario 'successfully' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer, motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, motorization: '1.7', car_category: car_category, fuel_type: 'diesel')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'

    expect(page).to have_content('Uno')
    expect(page).to have_content('2017')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('1.7')
    expect(page).to have_content(/B/)
    expect(page).to have_content('diesel')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer, motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, motorization: '1.7', car_category: car_category, fuel_type: 'diesel')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and car models dont exist' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'

    expect(page).to have_content('Nenhum modelo de carro cadastrado')
  end

  scenario 'and must be authenticated via routes' do
    visit car_models_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated via button' do
    visit root_path

    expect(page).not_to have_link('Modelos de Carro')
  end

  scenario 'and must be authenticated to view details' do
    visit car_model_path('dont care')

    expect(current_path).to eq(new_user_session_path)
  end

end