require 'rails_helper'

feature 'Admin register car model' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:manufacturer, name: 'Fiat')
    create(:manufacturer, name: 'Volkswagen')
    create(:car_category, name: 'A')
    create(:car_category, name: 'B')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Registrar novo modelo'
    fill_in 'Nome', with: 'Uno'
    fill_in 'Ano', with: '2017'
    select 'Fiat', from: 'Fabricante'
    fill_in 'Motorização', with: '1.7'
    select 'B', from: 'Categoria'
    fill_in 'Tipo de Combustível', with: 'diesel'
    click_on 'Enviar'

    expect(page).to have_content('Uno')
    expect(page).to have_content('2017')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('1.7')
    expect(page).to have_content(/B/)
    expect(page).to have_content('diesel')
    expect(page).to have_content('Modelo de carro registrado com sucesso')
  end

  scenario 'and must fill in all fields' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Registrar novo modelo'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Ano não pode ficar em branco')
    expect(page).to have_content('Fabricante não pode ficar em branco')
    expect(page).to have_content('Motorização não pode ficar em branco')
    expect(page).to have_content('Categoria não pode ficar em branco')
    expect(page).to have_content('Tipo de Combustível não pode ficar em branco')
  end

  scenario 'and must be authenticated via routes' do
    visit new_car_model_path

    expect(current_path).to eq(new_user_session_path)
  end
end