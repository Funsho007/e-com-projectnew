class Tag < ApplicationRecord
  has_and_belongs_to_many :products


# app/models/product.rb
class Product < ApplicationRecord
  has_and_belongs_to_many :tags

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end
end
