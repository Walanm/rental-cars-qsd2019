require 'rails_helper'

feature 'User sign in' do
  scenario 'successfully' do
    User.create!(email: 'usuario@gmail.com', password: 'usuario123')

    visit root_path
    click_on 'Entrar'

    within 'form' do
      fill_in 'Email', with: 'usuario@gmail.com'
      fill_in 'Senha', with: 'usuario123'
      click_on 'Entrar'
    end

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_link('Sair')
    expect(page).not_to have_link('Entrar')
    expect(current_path).to eq(root_path)
  end
end