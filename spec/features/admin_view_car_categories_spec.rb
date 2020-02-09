require 'rails_helper'

feature 'Admin view car categories' do
  scenario 'successfully' do
    # Arrange
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:car_category, name: 'A', daily_rate: 19.5,
                          car_insurance: 700.95, third_party_insurance: 200.1)
    create(:car_category, name: 'B')

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
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:car_category, name: 'A')
    create(:car_category, name: 'B')

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
end
