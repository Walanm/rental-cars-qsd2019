require 'rails_helper'

describe CarRental do
  describe 'validates' do
    it 'daily_rate must exist' do
      car = Car.new(license_plate: 'NVN1010')
      rental = Rental.new(code: 'XFB0000')
      car_rental = CarRental.new(car: car, rental: rental, daily_rate: nil,
                                 car_insurance: 90.5,
                                 third_party_insurance: 100.1,
                                 start_mileage: 200)

      car_rental.valid?

      expect(car_rental.errors[:daily_rate])
        .to include('não pode ficar em branco')
    end

    it 'car_insurance must exist' do
      car = Car.new(license_plate: 'NVN1010')
      rental = Rental.new(code: 'XFB0000')
      car_rental = CarRental.new(car: car, rental: rental, daily_rate: 90.5,
                                 car_insurance: nil,
                                 third_party_insurance: 100.1,
                                 start_mileage: 200)
      car_rental.valid?

      expect(car_rental.errors[:car_insurance])
        .to include('não pode ficar em branco')
    end

    it 'third_party_insurance must exist' do
      car = Car.new(license_plate: 'NVN1010')
      rental = Rental.new(code: 'XFB0000')
      car_rental = CarRental.new(car: car, rental: rental, daily_rate: 90.5,
                                 car_insurance: 100.1,
                                 third_party_insurance: nil,
                                 start_mileage: 200)

      car_rental.valid?

      expect(car_rental.errors[:third_party_insurance])
        .to include('não pode ficar em branco')
    end

    it 'start_mileage must exist' do
      car = Car.new(license_plate: 'NVN1010')
      rental = Rental.new(code: 'XFB0000')
      car_rental = CarRental.new(car: car, rental: rental, daily_rate: 90.5,
                                 car_insurance: 190.8,
                                 third_party_insurance: 100.1,
                                 start_mileage: nil)

      car_rental.valid?

      expect(car_rental.errors[:start_mileage])
        .to include('não pode ficar em branco')
    end
  end
end
