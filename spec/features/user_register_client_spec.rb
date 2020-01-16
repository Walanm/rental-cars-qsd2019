require 'rails_helper'

feature 'User registers client' do
  scenario 'successfully' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    fill_in 'Nome', with: 'João da Silva'
    fill_in 'Email', with: 'joao@joao.com'
    fill_in 'CPF', with: '696.699.680-70'
    click_on 'Enviar'

    expect(page).to have_content('Cliente registrado com sucesso')
    expect(page).to have_content('João da Silva')
    expect(page).to have_content('joao@joao.com')
    expect(page).to have_content('696.699.680-70')
  end

  scenario 'and must fill all fields' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Clientes'
    click_on 'Cadastrar novo cliente'
    click_on 'Enviar'

    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Email não pode ficar em branco')
    expect(page).to have_content('CPF não pode ficar em branco')
  end

  scenario 'and must be authenticated via routes' do
    visit new_client_path

    expect(current_path).to eq(new_user_session_path)
  end
end