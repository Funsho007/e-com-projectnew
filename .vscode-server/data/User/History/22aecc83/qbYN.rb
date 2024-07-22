class Type < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end
end
