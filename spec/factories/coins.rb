FactoryBot.define do
  factory :coin do
    name { 'Bitcoin' }
    total { 2 }
    association :wallet
  end
end
