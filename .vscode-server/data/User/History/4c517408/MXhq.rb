class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :orders
  has_many :order_items
  has_one_attached :image
end
