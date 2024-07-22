class Tag < ApplicationRecord
  has_and_belongs_to_many :products

  

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end
end
