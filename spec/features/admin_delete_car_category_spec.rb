require 'rails_helper'

feature 'Admin deletes car category' do
  scenario 'successfully' do
    # Arrange
    CarCategory.create!(name: 'Entrada', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'Hatch Pequeno', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    # Act
    visit root_path
    click_on 'Categorias'
    click_on 'Entrada'
    click_on 'Apagar'

    # Assert
    expect(page).not_to have_content('Entrada')
    expect(page).to have_content('Hatch Pequeno')
  end
end