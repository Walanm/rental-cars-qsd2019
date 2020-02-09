FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'f4k3p455w0rd' }
    subsidiary { nil }
  end
end
