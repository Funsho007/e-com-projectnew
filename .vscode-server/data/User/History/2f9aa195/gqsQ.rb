class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :tags
  has_one_attached :image_url
  has_many :cart_items
  has_many :carts, through: :cart_items

  def self.ransackable_associations(auth_object = nil)
    ["brand", "category", "image_url_attachment", "image_url_blob", "order_items", "orders", "tags", "type"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "price", "stock", "updated_at", "on_sale_status"]
  end

  validates :name, :price, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :on_sale_status, inclusion: { in: [true, false] }

  def self.search(keyword, category_id = nil)
    if keyword.present?
      if category_id.present?
        where('name ILIKE ? OR description ILIKE ?', "%#{keyword}%", "%#{keyword}%")
          .where(category_id: category_id)
      else
        where('name ILIKE ? OR description ILIKE ?', "%#{keyword}%", "%#{keyword}%")
      end
    else
      all
    end
  end
end
