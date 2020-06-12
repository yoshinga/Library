# uidはnipporailsのuser_idのこと

class User < ApplicationRecord
  validates :nickname, presence: true
  validates :uid, presence: true, uniqueness: true

  has_many :books
  has_many :wish_lists
  has_many :books
end
