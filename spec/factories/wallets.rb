FactoryBot.define do
  factory :wallet do
    entity { create([:user, :team, :stock].sample) }
  end
end