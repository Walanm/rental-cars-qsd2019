require 'rails_helper'

feature 'Admin register manufacturer' do
  scenario 'successfully' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: 'Fiat'
    click_on 'Enviar'

    expect(page).to have_content('Fiat')
    expect(page).to have_content('Fabricante criada com sucesso')
  end

  scenario 'and must fill in all fields' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'name must be unique' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)
    Manufacturer.create!(name: 'Honda')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Registrar novo fabricante'

    fill_in 'Nome', with: 'Honda'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end

  scenario 'and must be authenticated via routes' do
    visit new_manufacturer_path

    expect(current_path).to eq(new_user_session_path)
  end
end