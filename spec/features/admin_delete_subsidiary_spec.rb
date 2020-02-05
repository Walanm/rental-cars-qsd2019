require 'rails_helper'

feature 'Admin deletes subsidiary' do
  scenario 'successfully' do
    # Arrange
    subsidiary = create(:subsidiary, name: 'Alamo')
    create(:subsidiary, name: 'Hertz')
    user = create(:user, subsidiary: subsidiary)

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Apagar'

    # Assert
    expect(page).not_to have_content('Alamo')
    expect(page).to have_content('Hertz')
  end

  scenario 'and must be authenticated via routes' do
    subsidiary = create(:subsidiary)
    
    visit subsidiary_path(subsidiary.name)

    expect(current_path).to eq(new_user_session_path)
  end
end