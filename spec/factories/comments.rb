FactoryBot.define do
  factory :comment do
    association :user
    association :book
    content { "It was good book" }
  end
end
