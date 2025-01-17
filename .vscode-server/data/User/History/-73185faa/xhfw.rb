# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :customer, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "products"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "gst", "hst", "id", "order_date", "pst", "qst", "status", "total_amount", "updated_at", "customer_id"]
  end

  validates :order_date, presence: true
  validates :gst, :hst, :pst, :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[new paid shipped] }

  def add_cart_items(cart)
    cart.cart_items.each do |item|
      order_items.create(
        product: item.product,
        quantity: item.quantity,
        price: item.product.price
      )
    end
  end

  def calculate_total
    self.total_amount = order_items.sum('quantity * price')
  end
end
