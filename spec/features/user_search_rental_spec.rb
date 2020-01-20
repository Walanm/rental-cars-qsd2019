require 'rails_helper'

feature 'User search rental' do
  scenario 'successfully' do
    user = User.create!(email: 'fake@user.com', password: 'fAk3pA55w0rd')
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                       car_insurance: 700.95, third_party_insurance: 200.1)
    Rental.create!(code: 'XFB000', start_date: '19/01/2040', end_date: '22/01/2040', 
                   client: client, car_category: car_category, user: user)
    Rental.create!(code: 'XFB001', start_date: '26/01/2040', end_date: '29/01/2040', 
                   client: client, car_category: car_category, user: user)
    Rental.create!(code: 'XFB002', start_date: '01/02/2040', end_date: '04/02/2040', 
                   client: client, car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'xfb000'
    click_on 'Buscar'

    expect(page).to have_content('XFB000')
    expect(page).to have_content('João da Silva')
    expect(page).to have_content('19/01/2040')
    expect(page).to have_content('22/01/2040')
    expect(page).to have_content('fake@user.com')
    expect(page).not_to have_content('XFB001')
    expect(page).not_to have_content('XFB002')
  end

  scenario 'and rental not found' do
    user = User.create!(email: 'fake@user.com', password: 'fAk3pA55w0rd')
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                       car_insurance: 700.95, third_party_insurance: 200.1)
    Rental.create!(code: 'XFB002', start_date: '01/02/2040', end_date: '04/02/2040', 
                   client: client, car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'xfb000'
    click_on 'Buscar'

    expect(page).to have_content('Nenhum resultado encontrado para o termo xfb000')
    expect(page).not_to have_content('XFB002')
  end

  scenario 'partially' do
    user = User.create!(email: 'fake@user.com', password: 'fAk3pA55w0rd')
    client = Client.create!(name: 'João da Silva', email: 'client@client.com', document: '696.699.680-70')
    car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                       car_insurance: 700.95, third_party_insurance: 200.1)
    Rental.create!(code: 'XFB000', start_date: '19/01/2040', end_date: '22/01/2040', 
                   client: client, car_category: car_category, user: user)
    Rental.create!(code: 'XFB001', start_date: '26/01/2040', end_date: '29/01/2040', 
                   client: client, car_category: car_category, user: user)
    Rental.create!(code: 'XAB002', start_date: '01/02/2040', end_date: '04/02/2040', 
                   client: client, car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'xf'
    click_on 'Buscar'

    expect(page).to have_content('XFB000')
    expect(page).to have_content('João da Silva', count: 2)
    expect(page).to have_content('19/01/2040')
    expect(page).to have_content('22/01/2040')
    expect(page).to have_content('fake@user.com', count: 2)
    expect(page).to have_content('XFB001')
    expect(page).to have_content('26/01/2040')
    expect(page).to have_content('29/01/2040')
    expect(page).to have_content('fake@user.com')
    expect(page).not_to have_content('XAB002')
  end
end