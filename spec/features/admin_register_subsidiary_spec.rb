require 'rails_helper'

feature 'Admin register subsidiary' do
  scenario 'successfully' do
    visit root_path
    click_on 'Filiais'
    click_on 'Registrar nova filial'

    fill_in 'Nome', with: 'Alamo'
    fill_in 'CNPJ', with: '45.251.445/0001-82'
    fill_in 'Endereço', with: 'Rua da Consolação 101'
    click_on 'Enviar'

    expect(page).to have_content('Alamo')
    expect(page).to have_content('45.251.445/0001-82')
    expect(page).to have_content('Rua da Consolação 101')
    expect(page).to have_content('Filial criada com sucesso')
  end

  scenario 'name must be unique' do
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')

    visit root_path
    click_on 'Filiais'
    click_on 'Registrar nova filial'

    fill_in 'Nome', with: 'Alamo'
    fill_in 'CNPJ', with: '45.251.445/0001-82'
    fill_in 'Endereço', with: 'Rua da Consolação 101'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end

  scenario 'cnpj must be valid' do
    visit root_path
    click_on 'Filiais'
    click_on 'Registrar nova filial'

    fill_in 'Nome', with: 'Alamo'
    fill_in 'CNPJ', with: '45.25-82'
    fill_in 'Endereço', with: 'Rua da Consolação 101'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('CNPJ deve ser válido')
  end
end