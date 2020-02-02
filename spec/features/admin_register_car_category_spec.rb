require 'rails_helper'

feature 'Admin register car category' do
  scenario 'successfully' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'

    fill_in 'Nome', with: 'A'
    fill_in 'Taxa Diária', with: '19.5'
    fill_in 'Seguro do Carro', with: '700.95'
    fill_in 'Seguro contra Terceiros', with: '200.1'
    click_on 'Enviar'

    expect(page).to have_content(/A/)
    expect(page).to have_content('19.5')
    expect(page).to have_content('700.95')
    expect(page).to have_content('200.1')
    expect(page).to have_content('Categoria criada com sucesso')
  end

  scenario 'and must fill in all fields' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'

    fill_in 'Nome', with: ''
    fill_in 'Taxa Diária', with: ''
    fill_in 'Seguro do Carro', with: ''
    fill_in 'Seguro contra Terceiros', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Taxa Diária não pode ficar em branco')
    expect(page).to have_content('Seguro do Carro não pode ficar em branco')
    expect(page).to have_content('Seguro contra Terceiros não pode ficar em branco')
  end

  scenario 'and values must be greater than zero' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'

    fill_in 'Nome', with: 'A'
    fill_in 'Taxa Diária', with: '-1.0'
    fill_in 'Seguro do Carro', with: '-2.5'
    fill_in 'Seguro contra Terceiros', with: '-3.7'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Taxa Diária deve ser maior que zero')
    expect(page).to have_content('Seguro do Carro deve ser maior que zero')
    expect(page).to have_content('Seguro contra Terceiros deve ser maior que zero')
  end

  scenario 'and must be authenticated via button' do
    visit new_car_category_path

    expect(current_path).to eq(new_user_session_path)
  end
end