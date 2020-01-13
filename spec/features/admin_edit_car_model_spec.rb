require 'rails_helper'

feature 'Admin edit car model' do
  scenario 'successfully' do
    manufacturer = Manufacturer.create!(name: 'Fiat')
    Manufacturer.create!(name: 'Volkswagen')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, motorization: '1.7', car_category: car_category, fuel_type: 'diesel')

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
    expect(page).to have_content('Modelo atualizado com sucesso')
  end

  scenario 'and must fill in all fields' do
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, motorization: '1.7', car_category: car_category, fuel_type: 'diesel')

    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Ano', with: ''
    fill_in 'Motorização', with: ''
    fill_in 'Tipo de Combustível', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Ano não pode ficar em branco')
    #expect(page).to have_content('Fabricante não pode ficar em branco')
    expect(page).to have_content('Motorização não pode ficar em branco')
    #expect(page).to have_content('Categoria de Carro não pode ficar em branco')
    expect(page).to have_content('Tipo de Combustível não pode ficar em branco')
  end
end