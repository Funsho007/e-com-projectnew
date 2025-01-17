class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :primary_province, class_name: 'Province', optional: true
  belongs_to :alt_province, class_name: 'Province', optional: true
  has_many :orders

  # Custom validation method to check Canadian postal code format
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

  # Define the ransackable associations method
  def self.ransackable_associations(auth_object = nil)
    %w[alt_province orders primary_province]
  end

  # Define the ransackable attributes method
  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name email primary_address primary_city primary_postal_code alt_address alt_city alt_postal_code created_at updated_at]
  end

  # Define the full_name method
  def full_name
    "#{first_name} #{last_name}"
  end
end
