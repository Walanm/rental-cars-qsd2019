require 'rails_helper'

feature 'Admin register car category' do
  scenario 'successfully' do
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'

    fill_in 'Nome', with: 'Entrada'
    fill_in 'Taxa Diária', with: '19.5'
    fill_in 'Seguro do Carro', with: '700.95'
    fill_in 'Seguro contra Terceiros', with: '200.1'
    click_on 'Enviar'

    expect(page).to have_content('Entrada')
    expect(page).to have_content('19.5')
    expect(page).to have_content('700.95')
    expect(page).to have_content('200.1')
    expect(page).to have_content('Categoria criada com sucesso')
  end

  scenario 'and must fill in all fields' do
    visit root_path
    click_on 'Categorias'
    click_on 'Registrar nova categoria'

    fill_in 'Nome', with: ''
    fill_in 'Taxa Diária', with: ''
    fill_in 'Seguro do Carro', with: ''
    fill_in 'Seguro contra Terceiros', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Você deve corrigir os seguintes erros para continuar')
    expect(page).to have_content('Você deve informar todos os dados da categoria')
  end
end