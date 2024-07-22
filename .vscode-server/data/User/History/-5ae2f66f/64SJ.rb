class Order < ApplicationRecord
  belongs_to :customer, optional: true
  has_many :order_items
  has_many :products, through: :order_items

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "products"]
    ["created_at", "gst", "hst", "id", "id_value", "order_date", "pst", "qst", "status", "total_amount", "updated_at", "user_id"]
  end

  validates :order_date, presence: true
  validates :GST, :HST, :PST, :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[new paid shipped] }
end
