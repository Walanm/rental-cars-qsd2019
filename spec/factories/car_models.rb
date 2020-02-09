FactoryBot.define do
  factory :car_model do
    name { 'Mobi' }
    year { '2019' }
    manufacturer { nil }
    motorization { '1.6' }
    car_category { nil }
    fuel_type { 'gasoline' }
  end
end
