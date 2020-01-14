require 'rails_helper'

feature 'Admin view subsidiaries' do
  scenario 'successfully' do
    # Arrange
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    Subsidiary.create!(name: 'Hertz', cnpj: '52.675.752/0001-56', address: 'Avenida Brasil 67')

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'

    # Assert
    expect(page).to have_content('Alamo')
    expect(page).to have_content('45.251.445/0001-82')
    expect(page).to have_content('Rua da Consolação 101')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    Subsidiary.create!(name: 'Hertz', cnpj: '52.675.752/0001-56', address: 'Avenida Brasil 67')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and must be authenticated via routes' do
    visit subsidiaries_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated via button' do
    visit root_path

    expect(page).not_to have_link('Filiais')
  end

  scenario 'and must be authenticated to view details' do
    subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    
    visit subsidiary_path(subsidiary.name)

    expect(current_path).to eq(new_user_session_path)
  end
end