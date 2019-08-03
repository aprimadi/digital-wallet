FactoryBot.define do
  factory :wallet do
    entity { [User, Team, Stock].sample.new }
  end
end