require 'rails_helper'

feature 'User register rental' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    client = create(:client)
    manufacturer = build(:manufacturer)
    car_category = create(:car_category, name: 'A')
    car_model = build(:car_model, manufacturer: manufacturer,
                                  car_category: car_category)
    car = create(:car, car_model: car_model, subsidiary: subsidiary)

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
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    client = create(:client)
    manufacturer = build(:manufacturer)
    car_category = create(:car_category, name: 'A')

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
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    client = create(:client)
    manufacturer = build(:manufacturer)
    car_category = create(:car_category, name: 'A')

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
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    client = create(:client)
    manufacturer = build(:manufacturer)
    car_category = create(:car_category, name: 'A')

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