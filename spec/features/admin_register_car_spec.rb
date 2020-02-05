require 'rails_helper'

feature 'Admin register car' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary, name: 'Alamo')
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer)
    car_category = create(:car_category)
    create(:car_model, name: 'Uno', manufacturer: manufacturer, 
                       car_category: car_category)
    
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
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    subsidiary.delete
    
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
    subsidiary = create(:subsidiary, name: 'Alamo')
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer)
    car_category = create(:car_category)
    car_model = create(:car_model, name: 'Uno', manufacturer: manufacturer, 
                                   car_category: car_category)
    create(:car, license_plate: 'NVN1010', car_model: car_model,
                 subsidiary: subsidiary)
    
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
    subsidiary = create(:subsidiary, name: 'Alamo')
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer)
    car_category = create(:car_category)
    create(:car_model, name: 'Uno', manufacturer: manufacturer, 
                       car_category: car_category)

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