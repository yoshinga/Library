FactoryBot.define do
  factory :comment do
    association :user
    association :book
    sequence(:content) { |n| "It was good book #{n}" }
  end
end
