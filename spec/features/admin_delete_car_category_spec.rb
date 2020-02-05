require 'rails_helper'

feature 'Admin deletes car category' do
  scenario 'successfully' do
    # Arrange
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:car_category, name: 'A')
    create(:car_category, name: 'B')

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
    car_category = create(:car_category)
    
    visit car_category_path(car_category.name)

    expect(current_path).to eq(new_user_session_path)
  end
end