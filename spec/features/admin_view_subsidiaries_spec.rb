require 'rails_helper'

feature 'Admin view subsidiaries' do
  scenario 'successfully' do
    # Arrange
    subsidiary = create(:subsidiary, name: 'Alamo', cnpj: '45.251.445/0001-82',
                                     address: 'Rua da Consolação 101')
    create(:subsidiary,name: 'Hertz')
    user = create(:user, subsidiary: subsidiary)

    # Act
    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'

    # Assert
    expect(page).to have_content('Alamo')
    expect(page).to have_content('45.251.445/0001-82')
    expect(page).to have_content('Rua da Consolação 101')
    expect(page).not_to have_content('Hertz')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    subsidiary = create(:subsidiary, name: 'Alamo')
    user = create(:user, subsidiary: subsidiary)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Filiais'
    click_on 'Alamo'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end

  scenario 'and must be authenticated via routes' do
    visit subsidiaries_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario 'and must be authenticated via button' do
    visit root_path

    expect(page).not_to have_link('Filiais')
  end
end