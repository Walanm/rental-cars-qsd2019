FactoryBot.define do
  factory :car_rental do
    car { nil }
    rental { nil }
    daily_rate { 90.5 }
    car_insurance { 100.1 }
    third_party_insurance { 230.1 }
    start_mileage { 170 }
    end_mileage { nil }
  end
end