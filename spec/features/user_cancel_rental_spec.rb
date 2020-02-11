require 'rails_helper'

feature 'User cancel rental' do
  scenario 'sucessfully' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    car_category = create(:car_category)
    client = create(:client)
    manufacturer = create(:manufacturer)
    car_model = create(:car_model, manufacturer: manufacturer,
                                   car_category: car_category)
    create(:car, car_model: car_model, subsidiary: subsidiary)
    create(:rental, code: 'XFB0000', client: client,
                    car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'XFB000'
    click_on 'Buscar'
    click_on 'Cancelar Locação'
    fill_in 'Motivo de cancelamento', with: 'A viagem foi adiada'
    click_on 'Finalizar Cancelamento'

    expect(page).to have_content('Locação cancelada com sucesso')
    expect(page).to have_content('XFB0000')
    expect(page).to have_content('Status: Cancelado')
  end

  scenario 'and cancellation reason cannot be empty' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    car_category = create(:car_category, name: 'A')
    client = create(:client)
    manufacturer = create(:manufacturer, name: 'Fiat')
    car_model = create(:car_model, name: 'Mobi', manufacturer: manufacturer,
                                   car_category: car_category)
    create(:car, license_plate: 'NVN1010', color: 'Azul',
                 car_model: car_model, subsidiary: subsidiary)
    create(:rental, code: 'XFB0000', client: client,
                    car_category: car_category, user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'XFB000'
    click_on 'Buscar'
    click_on 'Cancelar Locação'
    click_on 'Finalizar Cancelamento'

    expect(page).to have_content('XFB0000')
    expect(page).to have_content('Você deve corrigir os seguintes erros para' \
                                 ' continuar')
    expect(page).to have_content('Motivo de cancelamento não pode ficar' \
                                 ' em branco')
  end

  scenario 'and must be more than 24h before rental start date' do
    subsidiary = create(:subsidiary)
    user = create(:user, subsidiary: subsidiary)
    car_category = create(:car_category)
    client = create(:client)
    manufacturer = create(:manufacturer)
    car_model = create(:car_model, manufacturer: manufacturer,
                                   car_category: car_category)
    create(:car, car_model: car_model, subsidiary: subsidiary)
    create(:rental, code: 'XFB0000', client: client,
                    car_category: car_category, user: user,
                    start_date: Date.current)

    login_as user, scope: :user
    visit root_path
    click_on 'Locações'
    fill_in 'Pesquisa', with: 'XFB000'
    click_on 'Buscar'
    click_on 'Cancelar Locação'
    fill_in 'Motivo de cancelamento', with: 'A viagem foi adiada'
    click_on 'Finalizar Cancelamento'

    expect(page).to have_content('XFB0000')
    expect(page).to have_content('Você deve corrigir os seguintes erros para' \
                                 ' continuar')
    expect(page).to have_content('Você só pode cancelar uma locação' \
                                 ' com no mínimo um dia de antecedência')
  end
end