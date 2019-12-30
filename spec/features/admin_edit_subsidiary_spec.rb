require 'rails_helper'

feature 'Admin edits subsidiary' do
  scenario 'successfully' do
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')

    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Editar'
    fill_in 'Nome', with: 'Hertz'
    fill_in 'CNPJ', with: '52.675.752/0001-56'
    fill_in 'Endereço', with: 'Avenida Brasil 67'
    click_on 'Enviar'

    expect(page).to have_content('Hertz')
    expect(page).to have_content('52.675.752/0001-56')
    expect(page).to have_content('Avenida Brasil 67')
  end

  scenario 'name must be unique' do
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    Subsidiary.create!(name: 'Hertz', cnpj: '52.675.752/0001-56', address: 'Avenida Brasil 67')

    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Editar'

    fill_in 'Nome', with: 'Hertz'
    fill_in 'CNPJ', with: '52.675.752/0001-56'
    fill_in 'Endereço', with: 'Avenida Brasil 67'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end

  scenario 'cnpj must be valid' do
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')

    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Editar'

    fill_in 'Nome', with: 'Alamo'
    fill_in 'CNPJ', with: '45.25-82'
    fill_in 'Endereço', with: 'Rua da Consolação 101'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('CNPJ deve ser válido')
  end
end