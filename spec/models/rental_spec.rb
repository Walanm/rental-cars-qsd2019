require 'rails_helper'

describe Rental do
  describe '#start_date_cannot_be_in_the_past' do
    it 'validates successfully' do
      rental = Rental.new(start_date: 1.day.ago, end_date: 10.days.from_now)

      rental.valid?

      expect(rental.errors[:start_date])
        .to include('Data de início não pode ser no passado')
    end

    it 'doesnt have start date' do
      rental = Rental.new(start_date: nil, end_date: Date.current)

      rental.valid?

      expect(rental.errors[:start_date])
        .not_to include('Data de início não pode ser no passado')
      expect(rental.errors[:start_date])
        .to include('Data de Início não pode ficar em branco')
    end
  end

  describe '#end_date_greater_than_start_date' do
    it 'validates successfully' do
      rental = Rental.new(start_date: 1.day.from_now, end_date: 1.day.ago)

      rental.valid?

      expect(rental.errors[:end_date])
        .to include('Data de término deve ser após data de início')
    end

    it 'doesnt have end date' do
      rental = Rental.new(start_date: Date.current, end_date: nil)

      rental.valid?

      expect(rental.errors[:end_date])
        .not_to include('Data de término deve ser após data de início')
      expect(rental.errors[:end_date])
        .to include('Data de Término não pode ficar em branco')
    end

    it 'doesnt have start date' do
      rental = Rental.new(start_date: nil, end_date: Date.current)

      rental.valid?

      expect(rental.errors[:end_date]).not_to include('Data de término deve' \
                                                      ' ser após data de' \
                                                      ' início')
      expect(rental.errors[:start_date]).to include('Data de Início não pode' \
                                                    ' ficar em branco')
    end
  end

  describe '#have_available_cars' do
    it 'has a rental end date within new rental period' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      client = create(:client)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: Date.current,
                     end_date: 4.days.from_now, client: client,
                     car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.days.from_now,
                          end_date: 6.days.from_now, client: client,
                          car_category: car_category, user: user)

      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis' \
                                              ' dessa categoria nesse período')
    end

    it 'has a rental start date within new rental period' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      client = create(:client)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: 4.days.from_now,
                     end_date: 8.days.from_now, client: client,
                     car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.days.from_now,
                          end_date: 6.days.from_now, client: client,
                          car_category: car_category, user: user)

      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis' \
                                              ' dessa categoria nesse período')
    end

    it 'has a rental period entirely within new rental period' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      client = create(:client)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: 4.days.from_now,
                     end_date: 5.days.from_now, client: client,
                     car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.days.from_now,
                          end_date: 6.days.from_now, client: client,
                          car_category: car_category, user: user)

      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis' \
                                              ' dessa categoria nesse período')
    end

    it 'has a rental period that covers entirely new rental period' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      client = create(:client)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: Date.current,
                     end_date: 8.days.from_now, client: client,
                     car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.days.from_now,
                          end_date: 6.days.from_now, client: client,
                          car_category: car_category, user: user)

      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis' \
                                              ' dessa categoria nesse período')
    end

    it 'has car available' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      client = create(:client)
      car_category = create(:car_category)
      manufacturer = Manufacturer.new(name: 'Fiat')
      car_model = create(:car_model, manufacturer: manufacturer,
                                     car_category: car_category)
      create(:car, car_model: car_model, subsidiary: subsidiary)
      rental = Rental.new(code: 'XFB0001', start_date: 2.days.from_now,
                          end_date: 6.days.from_now, client: client,
                          car_category: car_category, user: user)

      rental.valid?

      expect(rental.errors[:base]).to eq([])
    end

    it 'only has available car in other category' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary)
      car_category = create(:car_category, name: 'A')
      other_car_category = create(:car_category, name: 'B')
      client = create(:client)
      manufacturer = create(:manufacturer, name: 'Fiat')
      car_model = create(:car_model, name: 'Mobi', manufacturer: manufacturer,
                                     car_category: car_category)
      other_car_model = create(:car_model, name: 'Uno',
                                           manufacturer: manufacturer,
                                           car_category: other_car_category)
      create(:car, license_plate: 'NVN1010', color: 'Azul',
                   car_model: car_model, subsidiary: subsidiary)
      create(:car, license_plate: 'ABC1122', color: 'Vermelho',
                   car_model: other_car_model,
                   subsidiary: subsidiary)
      Rental.create!(code: 'XFB0000', start_date: 4.days.from_now,
                     end_date: 5.days.from_now, client: client,
                     car_category: car_category, user: user)
      rental = Rental.new(code: 'XFB0001', start_date: 2.days.from_now,
                          end_date: 6.days.from_now, client: client,
                          car_category: car_category, user: user)

      rental.valid?

      expect(rental.errors[:base]).to include('Não há carros disponíveis' \
                                              ' dessa categoria nesse período')
    end
  end
end
