require 'rails_helper'

describe Rental do
  describe '#start_date_cannot_be_in_the_past' do
    it 'validates successfully' do
      rental = Rental.new(start_date: 1.day.ago, end_date: 10.days.from_now)
      rental.valid?
      expect(rental.errors[:start_date]).to include('Data de início não pode ser no passado')
    end

    it 'validates presence' do
      rental = Rental.new(start_date: nil, end_date: Date.current)
      rental.valid?
      expect(rental.errors[:start_date]).to include('Data de Início não pode ficar em branco')
    end
  end

  describe '#end_date_greater_than_start_date' do
    it 'validates successfully' do
      rental = Rental.new(start_date: 1.day.from_now, end_date: 1.day.ago)
      rental.valid?
      expect(rental.errors[:end_date]).to include('Data de término deve ser após data de início')
    end

    it 'validates presence' do
      rental = Rental.new(start_date: Date.current, end_date: nil)
      rental.valid?
      expect(rental.errors[:end_date]).to include('Data de Término não pode ficar em branco')
    end
  end
end
