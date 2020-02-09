require 'rails_helper'

feature 'User sign in' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary)
    User.create!(email: 'usuario@gmail.com', password: 'usuario123',
                 subsidiary: subsidiary)

    visit root_path
    click_on 'Entrar'

    within 'form' do
      fill_in 'Email', with: 'usuario@gmail.com'
      fill_in 'Senha', with: 'usuario123'
      click_on 'Entrar'
    end

    expect(page).to have_content('Login efetuado com sucesso')
    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
    expect(current_path).to eq(root_path)
  end

  scenario 'and sign out' do
    subsidiary = create(:subsidiary)
    User.create!(email: 'usuario@gmail.com', password: 'usuario123',
                 subsidiary: subsidiary)

    visit root_path
    click_on 'Entrar'

    within 'form' do
      fill_in 'Email', with: 'usuario@gmail.com'
      fill_in 'Senha', with: 'usuario123'
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_content('Saiu com sucesso')
    expect(page).to have_link('Entrar')
    expect(page).not_to have_link('Sair')
    expect(current_path).to eq(root_path)
  end
end
