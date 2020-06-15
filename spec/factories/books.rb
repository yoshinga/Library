FactoryBot.define do
  factory :book do
    association :owner, factory: :user
    association :publisher
    status { "0" } # 0 => 未貸し出し, 1 => 貸し出し
    rent_user_id { "" }
    purchaser_id { "" }
    price { "1200" }
    author { "" }
    link { "" }
    latest_rent_date { "" }
    return_date { "" }
    purchase_date { "" }
    publication_date { "" }
  end
end
