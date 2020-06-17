class Publisher < ApplicationRecord
  has_one :book
  validates :publisher, presence: true, uniqueness: true

  scope :recent, -> { order(created_at: :desc) }
end
