class Token < ApplicationRecord
  attr_accessor :key

  validates :key, presence: true
  validates :label, presence: true
  before_save :rewrite_digest_hash

  def self.authenticate?(token)
    exists?(digest_hash: Digest::SHA512.hexdigest(token))
  end

  private

  def rewrite_digest_hash
    self.digest_hash = Digest::SHA512.hexdigest(key)
  end
end
