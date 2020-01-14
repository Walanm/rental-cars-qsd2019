require 'rails_helper'

feature 'Admin register subsidiary' do
  scenario 'successfully' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')

    login_as(user, scope: :user)
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
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')

    login_as(user, scope: :user)
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
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')

    login_as(user, scope: :user)
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

  scenario 'and must be authenticated via routes' do
    visit new_subsidiary_path

    expect(current_path).to eq(new_user_session_path)
  end
end