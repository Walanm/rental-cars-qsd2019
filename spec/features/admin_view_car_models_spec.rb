require 'rails_helper'

feature 'Admin view car models' do
  scenario 'successfully' do
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer, motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, motorization: '1.7', car_category: car_category, fuel_type: 'diesel')

    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'

    expect(page).to have_content('Uno')
    expect(page).to have_content('2017')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('1.7')
    expect(page).to have_content(/B/)
    expect(page).to have_content('diesel')
    expect(page).to have_link('Voltar')
  end

  scenario 'and return to home page' do
    manufacturer = Manufacturer.create!(name: 'Fiat')
    car_category = CarCategory.create!(name: 'B', daily_rate: 21.7,
                        car_insurance: 710.35, third_party_insurance: 150.1)
    CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer, motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
    CarModel.create!(name: 'Uno', year: '2017', manufacturer: manufacturer, motorization: '1.7', car_category: car_category, fuel_type: 'diesel')

    visit root_path
    click_on 'Modelos de Carro'
    click_on 'Uno'
    click_on 'Voltar'

    expect(current_path).to eq root_path
  end
end