require 'rails_helper'

feature 'Admin edits subsidiary' do
  scenario 'successfully' do
    CarCategory.create!(name: 'Entrada', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)

    visit root_path
    click_on 'Categorias'
    click_on 'Entrada'
    click_on 'Editar'
    fill_in 'Nome', with: 'Hatch Pequeno'
    fill_in 'Taxa Diária', with: '20.5'
    fill_in 'Seguro do Carro', with: '710.95'
    fill_in 'Seguro contra Terceiros', with: '210.1'
    click_on 'Enviar'

    expect(page).to have_content('Hatch Pequeno')
    expect(page).to have_content('20.5')
    expect(page).to have_content('710.95')
    expect(page).to have_content('210.1')
  end

  scenario 'and must fill in all fields' do
    CarCategory.create!(name: 'Entrada', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)

    visit root_path
    click_on 'Categorias'
    click_on 'Entrada'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Taxa Diária', with: ''
    fill_in 'Seguro do Carro', with: ''
    fill_in 'Seguro contra Terceiros', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Você deve informar todos os dados da categoria')
  end
end