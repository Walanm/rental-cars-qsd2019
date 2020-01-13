require 'rails_helper'

feature 'Admin register car model' do
  scenario 'successfully' do
    Manufacturer.create!(name: 'Fiat')
    Manufacturer.create!(name: 'Volkswagen')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)

    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Registrar novo modelo'

    fill_in 'Nome', with: 'Uno'
    fill_in 'Ano', with: '2017'
    select 'Fiat', from: 'Fabricante'
    fill_in 'Cavalos', with: '77'
    select 'B', from: 'Categoria'
    fill_in 'Tipo de Combustível', with: 'diesel'
    click_on 'Enviar'

    expect(page).to have_content('Uno')
    expect(page).to have_content('2017')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('77')
    expect(page).to have_content(/B/)
    expect(page).to have_content('diesel')
    expect(page).to have_content('Modelo criado com sucesso')
  end
end