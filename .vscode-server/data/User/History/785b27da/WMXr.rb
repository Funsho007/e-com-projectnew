# app/models/product.rb

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  belongs_to :type
  has_many :order_items
  has_and_belongs_to_many :tags
  has_one_attached :image

  validates :name, :description, :price, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "updated_at", "on_sale_status"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "brand", "type", "tags"]
  end
end
