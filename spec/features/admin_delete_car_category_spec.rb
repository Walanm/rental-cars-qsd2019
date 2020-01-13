require 'rails_helper'

feature 'Admin deletes car category' do
  scenario 'successfully' do
    # Arrange
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    # Act
    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Apagar'

    # Assert
    expect(page).not_to have_content(/A/)
    expect(page).to have_content(/B/)
  end
end