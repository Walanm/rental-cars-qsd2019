require 'rails_helper'

feature 'Admin view car categories' do
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

    # Assert
    expect(page).to have_content(/A/)
    expect(page).to have_content('19.5')
    expect(page).to have_content('700.95')
    expect(page).to have_content('200.1')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    user = User.create!(email: 'test@example.com', password: 'f4k3p455w0rd')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and must be authenticated via routes' do
    visit car_categories_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated via button' do
    visit root_path

    expect(page).not_to have_link('Categorias')
  end

  scenario 'and must be authenticated to view details' do
    car_category = CarCategory.new(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)
    
    visit car_category_path(car_category.name)

    expect(current_path).to eq(new_user_session_path)
  end
end