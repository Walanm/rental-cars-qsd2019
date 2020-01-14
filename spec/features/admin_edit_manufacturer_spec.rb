require 'rails_helper'

feature 'Admin edits manufacturer' do
  scenario 'successfully' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    Manufacturer.create(name: 'Fiat')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Editar'
    fill_in 'Nome', with: 'Honda'
    click_on 'Enviar'

    expect(page).to have_content('Honda')
  end

  scenario 'and must fill in all fields' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    Manufacturer.create(name: 'Fiat')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Editar'

    fill_in 'Nome', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
  end

  scenario 'name must be unique' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    Manufacturer.create(name: 'Fiat')
    Manufacturer.create!(name: 'Honda')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Editar'

    fill_in 'Nome', with: 'Honda'
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Nome deve ser único')
  end

  scenario 'and must be authenticated via routes' do
    manufacturer = Manufacturer.create(name: 'Fiat')
    
    visit edit_manufacturer_path(manufacturer.name)

    expect(current_path).to eq(new_user_session_path)
  end
end