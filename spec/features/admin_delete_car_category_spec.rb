require 'rails_helper'

feature 'Admin deletes car category' do
  scenario 'successfully' do
    # Arrange
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Apagar'

    # Assert
    expect(page).not_to have_content(/A/)
    expect(page).to have_content(/B/)
  end

  scenario 'and must be authenticated via routes' do
    car_category = CarCategory.new(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    
    visit car_category_path(car_category.name)

    expect(current_path).to eq(new_user_session_path)
  end
end