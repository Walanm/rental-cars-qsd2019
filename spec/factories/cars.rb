FactoryBot.define do
  factory :car do
    license_plate { 'NVN1010' }
    color { 'Azul' }
    car_model { nil }
    mileage { 127 }
    subsidiary { nil }
  end
end
