class Customer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :primary_province, class_name: 'Province', optional: true
  belongs_to :alt_province, class_name: 'Province', optional: true
  has_many :orders

  def self.ransackable_associations(auth_object = nil)
    ["orders", "primary_province", "alt_province"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "last_name", "primary_address", "primary_city", "primary_postal_code", "updated_at", "alt_address", "alt_city", "alt_postal_code"]
  end

  def canadian_postal_code_format
    if primary_postal_code.present? && !primary_postal_code.match(/\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/)
      errors.add(:primary_postal_code, "is not a valid Canadian postal code")
    end

    if alt_postal_code.present? && !alt_postal_code.match(/\A[A-Za-z]\d[A-Za-z] \d[A-Za-z]\d\z/)
      errors.add(:alt_postal_code, "is not a valid Canadian postal code")
    end
  end

  validates :first_name, :last_name, length: { maximum: 100 }
  validates :primary_address, :primary_city, :alt_address, :alt_city, allow_nil: true, length: { maximum: 100 }
  validate :canadian_postal_code_format
end
