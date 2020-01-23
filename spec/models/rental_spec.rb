require 'rails_helper'

describe Rental do
  describe '#start_date_cannot_be_in_the_past' do
    it 'validates successfully' do
      rental = Rental.new(start_date: 1.day.ago, end_date: 10.days.from_now)

      rental.valid?

      expect(rental.errors[:start_date]).to include('Data de início não pode ser no passado')
    end

    it 'doesnt have start date' do
      rental = Rental.new(start_date: nil, end_date: Date.current)

      rental.valid?

      expect(rental.errors[:start_date]).not_to include('Data de início não pode ser no passado')
      expect(rental.errors[:start_date]).to include('Data de Início não pode ficar em branco')
    end
  end

  describe '#end_date_greater_than_start_date' do
    it 'validates successfully' do
      rental = Rental.new(start_date: 1.day.from_now, end_date: 1.day.ago)

      rental.valid?

      expect(rental.errors[:end_date]).to include('Data de término deve ser após data de início')
    end

    it 'doesnt have end date' do
      rental = Rental.new(start_date: Date.current, end_date: nil)

      rental.valid?

      expect(rental.errors[:end_date]).not_to include('Data de término deve ser após data de início')
      expect(rental.errors[:end_date]).to include('Data de Término não pode ficar em branco')
    end

    it 'doesnt have start date' do
      rental = Rental.new(start_date: nil, end_date: Date.current)

      rental.valid?

      expect(rental.errors[:end_date]).not_to include('Data de término deve ser após data de início')
      expect(rental.errors[:start_date]).to include('Data de Início não pode ficar em branco')
    end
  end

  describe '#have_available_cars' do
    it 'has a rental end date within new rental period' do
      user = User.new(email: 'fake@user.com', password: 'fAk3pA55w0rd')
      subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                        car_insurance: 90.5, third_party_insurance: 100.1)
      client = Client.new(name: 'Fulano', email: 'fulano@test.com', document: '000.000.000-00')
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: Date.current, end_date: 4.day.from_now,
                     client: client, car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.day.from_now, end_date: 6.day.from_now,
                          client: client, car_category: car_category, user: user)
      
      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis dessa categoria nesse período')
    end

    it 'has a rental start date within new rental period' do
      user = User.new(email: 'fake@user.com', password: 'fAk3pA55w0rd')
      subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5, car_insurance: 90.5, third_party_insurance: 100.1)
      client = Client.new(name: 'Fulano', email: 'fulano@test.com',
                              document: '000.000.000-00')
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: 4.day.from_now, end_date: 8.day.from_now,
                     client: client, car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.day.from_now, end_date: 6.day.from_now,
                          client: client, car_category: car_category, user: user)
      
      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis dessa categoria nesse período')
    end

    it 'has a rental period entirely within new rental period' do
      user = User.new(email: 'fake@user.com', password: 'fAk3pA55w0rd')
      subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                        car_insurance: 90.5, third_party_insurance: 100.1)
      client = Client.new(name: 'Fulano', email: 'fulano@test.com', document: '000.000.000-00')
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: 4.day.from_now, end_date: 5.day.from_now,
                     client: client, car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.day.from_now, end_date: 6.day.from_now,
                          client: client, car_category: car_category, user: user)
      
      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis dessa categoria nesse período')
    end

    it 'has a rental period that covers entirely new rental period' do
      user = User.new(email: 'fake@user.com', password: 'fAk3pA55w0rd')
      subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82',
                                  address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                        car_insurance: 90.5, third_party_insurance: 100.1)
      client = Client.new(name: 'Fulano', email: 'fulano@test.com', document: '000.000.000-00')
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: Date.current, end_date: 8.day.from_now,
                     client: client, car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.day.from_now, end_date: 6.day.from_now,
                          client: client, car_category: car_category, user: user)
      
      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis dessa categoria nesse período')
    end

    it 'has car available' do
      user = User.new(email: 'fake@user.com', password: 'fAk3pA55w0rd')
      subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                        car_insurance: 90.5, third_party_insurance: 100.1)
      client = Client.new(name: 'Fulano', email: 'fulano@test.com', document: '000.000.000-00')
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      rental = Rental.new(code: 'XFB0001', start_date: 2.day.from_now, end_date: 6.day.from_now,
                          client: client, car_category: car_category, user: user)
      
      rental.valid?

      expect(rental.errors[:base]).to eq([])
    end

    it 'only has available car in other category' do
      user = User.new(email: 'fake@user.com', password: 'fAk3pA55w0rd')
      subsidiary = Subsidiary.new(name: 'Alamo', cnpj: '45.251.445/0001-82', 
                                      address: 'Rua da Consolação 101')
      car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                        car_insurance: 90.5, third_party_insurance: 100.1)
      client = Client.new(name: 'Fulano', email: 'fulano@test.com', document: '000.000.000-00')
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = CarModel.create!(name: 'Mobi', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: car_category, fuel_type: 'gasoline')
      other_car_category = CarCategory.create!(name: 'A', daily_rate: 19.5,
                                               car_insurance: 90.5, third_party_insurance: 100.1)
      other_car_model = CarModel.create!(name: 'FOX', year: '2019', manufacturer: manufacturer,
                                  motorization: '1.6', car_category: other_car_category, fuel_type: 'gasoline')
      other_car = Car.create!(license_plate: 'AVN1010', color: 'Azul', car_model: other_car_model, mileage: 127, 
                                  subsidiary: subsidiary)
      car = Car.create!(license_plate: 'NVN1010', color: 'Azul', car_model: car_model, mileage: 127, 
                        subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: 4.day.from_now, end_date: 5.day.from_now,
                    client: client, car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.day.from_now, end_date: 6.day.from_now,
                          client: client, car_category: car_category, user: user)
      
      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis dessa categoria nesse período')
    end
  end
end
