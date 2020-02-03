FactoryBot.define do
  factory :car_category do
    name { 'A' }
    daily_rate { 19.5 }
    car_insurance { 200.95 }
    third_party_insurance { 100.1 }
  end
end