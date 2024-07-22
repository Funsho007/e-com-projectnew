# class ProductCategory < ApplicationRecord
#   has_many :products

#   def self.ransackable_attributes(auth_object = nil)
#     ["created_at", "description", "id", "name", "updated_at"]
#   end
#   def self.ransackable_associations(auth_object = nil)
#     ["products"]
#   end
# end


class Product < ApplicationRecord
  belongs_to :product_category

  validates :name, :description, :price, :quantity, presence: true
end

