require 'rails_helper'

feature 'Admin view car categories' do
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

    # Assert
    expect(page).to have_content('Entrada')
    expect(page).to have_content('19.5')
    expect(page).to have_content('700.95')
    expect(page).to have_content('200.1')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    CarCategory.create!(name: 'Entrada', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'Hatch Pequeno', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)

    visit root_path
    click_on 'Categorias'
    click_on 'Entrada'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end