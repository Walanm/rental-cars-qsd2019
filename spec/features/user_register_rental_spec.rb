require 'rails_helper'

feature 'User register rental' do
  scenario 'successfully' do
    user = User.create!(email: 'fake@user.com', password: 'fAk3pA55w0rd')
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    CarCategory.create!(name: 'A', daily_rate: 19.5,
                        car_insurance: 700.95, third_party_insurance: 200.1)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    click_on 'Registrar locação'
    fill_in 'Data de início', with: '10/01/2040'
    fill_in 'Data de término', with: '15/01/2040'
    select "#{client.document} - #{client.name}", from: 'Cliente'
    select 'A', from: 'Categoria de Carro'
    click_on 'Enviar'

    expect(page).to have_content('Locação registrada com sucesso')
    expect(page).to have_content('10/01/2040')
    expect(page).to have_content('15/01/2040')
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.email)
    expect(page).to have_content(client.document)
    expect(page).to have_content(/A/)
    expect(page).to have_content(user.email)
    expect(Rental.last.code).to match(/[a-zA-Z0-9]+/)
  end

  scenario 'and must be authenticated via routes' do
    visit new_rental_path

    expect(current_path).to eq(new_user_session_path)
  end
end