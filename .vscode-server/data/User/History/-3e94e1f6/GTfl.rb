class Tag < ApplicationRecord

  has_and_belongs_to_many :products
  
  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[products] # Include any associations that you want to be searchable


  end
end
