class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "status", "total_price", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "products"]
  end
end
