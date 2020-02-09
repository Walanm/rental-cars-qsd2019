FactoryBot.define do
  factory :rental do
    code { 'XFB001' }
    start_date { '26/01/2040' }
    end_date { '29/01/2040' }
    client { nil }
    car_category { nil }
    user { nil }
  end
end
