class Brand < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end
end

class Customer < ApplicationRecord
  belongs_to :province

  def self.ransackable_attributes(auth_object = nil)
    %w[email first_name id last_name created_at updated_at]
  end
end

class Province < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at gst hst id name pst qst tax_type updated_at]
  end
end
