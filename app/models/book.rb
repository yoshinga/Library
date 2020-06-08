class Book < ApplicationRecord
  belongs_to :user
  has_many :comments
  belongs_to :publisher
end
