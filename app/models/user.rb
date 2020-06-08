class User < ApplicationRecord
  has_many :books
  has_many :wish_lists
  has_many :books
end
