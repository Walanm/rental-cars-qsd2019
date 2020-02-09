require 'rails_helper'

feature 'Admin edits car category' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:car_category, name: 'A')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Editar'
    fill_in 'Nome', with: 'B'
    fill_in 'Taxa Diária', with: '20.5'
    fill_in 'Seguro do Carro', with: '710.95'
    fill_in 'Seguro contra Terceiros', with: '210.1'
    click_on 'Enviar'

    expect(page).to have_content(/B/)
    expect(page).to have_content('20.5')
    expect(page).to have_content('710.95')
    expect(page).to have_content('210.1')
  end

  scenario 'and must fill in all fields' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    create(:car_category, name: 'A')

    login_as(user, scope: :user)
    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Taxa Diária', with: ''
    fill_in 'Seguro do Carro', with: ''
    fill_in 'Seguro contra Terceiros', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para' \
                                 ' continuar')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Taxa Diária não pode ficar em branco')
    expect(page).to have_content('Seguro do Carro não pode ficar em branco')
    expect(page).to have_content('Seguro contra Terceiros não pode ficar em' \
                                 ' branco')
  end

  scenario 'and must be authenticated via routes' do
    car_category = create(:car_category)

    visit edit_car_category_path(car_category.name)

    expect(current_path).to eq(new_user_session_path)
  end
end
