FactoryBot.define do
  factory :wish_list do
    association :user
    title { "Rubyベストプラクティス -プロフェッショナルによるコードとテクニック 大型本 – 2010/3/26" }
    author { "Gregory Brown" }
    price { "3520" }
    link { "https://www.amazon.co.jp/Gregory-Brown/dp/4873114454/ref=sr_1_5?__mk_ja_JP=カタカナ&crid=2OGG09929MYVQ&dchild=1&keywords=ruby+デザインパターン&qid=1592358790&sprefix=ruby%2Caps%2C802&sr=8-5" }
    publication_date { "2010-3-26" }
  end
end
