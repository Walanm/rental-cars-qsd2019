require 'rails_helper'

feature 'Admin edits subsidiary' do
  scenario 'successfully' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
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
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    Subsidiary.create!(name: 'Hertz', cnpj: '52.675.752/0001-56', address: 'Avenida Brasil 67')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
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
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd', subsidiary: subsidiary)

    login_as(user, scope: :user)
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

  scenario 'and must be authenticated via routes' do
    subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    
    visit edit_subsidiary_path(subsidiary.name)

    expect(current_path).to eq(new_user_session_path)
  end
end