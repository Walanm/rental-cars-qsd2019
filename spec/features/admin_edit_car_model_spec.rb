require 'rails_helper'

feature 'Admin edit car model' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer, name: 'Fiat')
    create(:manufacturer, name: 'Volkswagen')
    car_category = create(:car_category, name: 'A')
    create(:car_category, name: 'B')
    create(:car_model, name: 'Uno', year: '2017', manufacturer: manufacturer,
                       motorization: '1.7', car_category: car_category,
                       fuel_type: 'diesel')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'
    click_on 'Editar'

    fill_in 'Nome', with: 'Mobi'
    fill_in 'Ano', with: '2018'
    select 'Volkswagen', from: 'Fabricante'
    fill_in 'Motorização', with: '1.5'
    select 'B', from: 'Categoria'
    fill_in 'Tipo de Combustível', with: 'gasolina'
    click_on 'Enviar'

    expect(page).to have_content('Mobi')
    expect(page).to have_content('2018')
    expect(page).to have_content('Volkswagen')
    expect(page).to have_content('1.5')
    expect(page).to have_content(/B/)
    expect(page).to have_content('gasolina')
    expect(page).to have_content('Modelo de carro atualizado com sucesso')
  end

  scenario 'and must fill in all fields' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    manufacturer = create(:manufacturer, name: 'Fiat')
    car_category = create(:car_category, name: 'A')
    create(:car_model, name: 'Uno', manufacturer: manufacturer,
                       car_category: car_category)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Ano', with: ''
    fill_in 'Motorização', with: ''
    fill_in 'Tipo de Combustível', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para' \
                                 ' continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Ano não pode ficar em branco')
    expect(page).to have_content('Motorização não pode ficar em branco')
    expect(page).to have_content('Tipo de Combustível não pode ficar em' \
                                 ' branco')
  end

  scenario 'and must be authenticated via routes' do
    visit edit_car_model_path('dont care')

    expect(current_path).to eq(new_user_session_path)
  end
end
