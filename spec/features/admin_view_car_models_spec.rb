require 'rails_helper'

feature 'Admin view car models' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer, name: 'Fiat')
    car_category = create(:car_category, name: 'B', daily_rate: 21.7,
                                         car_insurance: 710.35, 
                                         third_party_insurance: 150.1)
    create(:car_model, name: 'Mobi', manufacturer: manufacturer,
                       car_category: car_category)
    create(:car_model, name: 'Uno', year: '2017', manufacturer: manufacturer,
                       motorization: '1.7', car_category: car_category,
                       fuel_type: 'diesel')

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
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer)
    car_category = create(:car_category)
    create(:car_model, name: 'Uno', manufacturer: manufacturer,
                       car_category: car_category)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and car models dont exist' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)

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