FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
  end

  factory :team do
    name { Faker::Company.name }
  end

  factory :stock do
    name { Faker::Alphanumeric.alpha(number: 4) }
  end
end