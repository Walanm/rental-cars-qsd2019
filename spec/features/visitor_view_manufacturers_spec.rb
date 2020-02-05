require 'rails_helper'

feature 'Visitor view manufacturers' do
  scenario 'successfully' do
    # Arrange
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:manufacturer, name: 'Fiat')
    create(:manufacturer)

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'

    # Assert
    expect(page).to have_content('Fiat')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:manufacturer, name: 'Fiat')
    create(:manufacturer)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Fabricantes'
    click_on 'Fiat'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and must be authenticated via routes' do
    visit manufacturers_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated via button' do
    visit root_path

    expect(page).not_to have_link('Fabricantes')
  end

  scenario 'and must be authenticated to view details' do
    manufacturer = build(:manufacturer)
    
    visit manufacturer_path(manufacturer.name)

    expect(current_path).to eq(new_user_session_path)
  end
end