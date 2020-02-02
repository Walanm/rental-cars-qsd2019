require 'rails_helper'

feature 'Visitor view manufacturers' do
  scenario 'successfully' do
    # Arrange
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'usuario@gmail.com', password: 'usuario123', subsidiary: subsidiary)
    Manufacturer.create!(name: 'Fiat')
    Manufacturer.create!(name: 'Volkswagen')

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'

    # Assert
    expect(page).to have_content('Fiat')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    subsidiary = Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    user = User.create!(email: 'usuario@gmail.com', password: 'usuario123', subsidiary: subsidiary)
    Manufacturer.create!(name: 'Fiat')
    Manufacturer.create!(name: 'Volkswagen')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and must be authenticated via routes' do
    visit manufacturers_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated via button' do
    visit root_path

    expect(page).not_to have_link('Fabricantes')
  end

  scenario 'and must be authenticated to view details' do
    manufacturer = Manufacturer.new(name: 'Fiat')
    
    visit manufacturer_path(manufacturer.name)

    expect(current_path).to eq(new_user_session_path)
  end
end