require 'rails_helper'

feature 'Admin deletes subsidiary' do
  scenario 'successfully' do
    # Arrange
    Subsidiary.create!(name: 'Alamo', cnpj: '45.251.445/0001-82', address: 'Rua da Consolação 101')
    Subsidiary.create!(name: 'Hertz', cnpj: '52.675.752/0001-56', address: 'Avenida Brasil 67')

    # Act
    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Apagar'

    # Assert
    expect(page).not_to have_content('Alamo')
    expect(page).to have_content('Hertz')
  end
end