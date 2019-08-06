FactoryBot.define do
  factory :wallet do
    entity do
      Entity.skip_callback(:create, :after, :generate_wallet)
      e = create([:user, :team, :stock].sample)
      Entity.set_callback(:create, :after, :generate_wallet)
      e
    end
  end
end