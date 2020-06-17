FactoryBot.define do
  factory :publisher do
    sequence(:publisher) { |n| "出版社#{n}" }
  end
end
