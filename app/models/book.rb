class Book < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :comments
  belongs_to :publisher

  scope :recent, -> { order(created_at: :desc) }
end
