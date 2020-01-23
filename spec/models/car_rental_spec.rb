require 'rails_helper'

describe CarRental do
  describe '#validates' do
    it 'daily_rate must exist' do
      car_rental = CarRental.new

      car_rental.valid?

      expect(car_rental.errors[:daily_rate]).to include('Taxa Diária não pode ficar em branco')
    end

    it 'car_insurance must exist' do
      car_rental = CarRental.new

      car_rental.valid?

      expect(car_rental.errors[:car_insurance]).to include('Seguro do Carro não pode ficar em branco')
    end

    it 'third_party_insurance must exist' do
      car_rental = CarRental.new

      car_rental.valid?

      expect(car_rental.errors[:third_party_insurance]).to include('Seguro contra Terceiros não pode ficar em branco')
    end

    it 'start_mileage must exist' do
      car_rental = CarRental.new

      car_rental.valid?

      expect(car_rental.errors[:start_mileage]).to include('Quilometragem Inicial não pode ficar em branco')
    end
  end
end

