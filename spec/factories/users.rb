FactoryBot.define do
  factory :user do
    nickname { "Adam Levine" }
    role { "100" }
    sequence(:uid) { |n| "#{n}" }
  end
end
