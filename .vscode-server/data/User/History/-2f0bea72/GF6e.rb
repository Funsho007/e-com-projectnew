class Brand < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end
end

class Category < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end
end

class Type < ApplicationRecord
  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end
end

class Tag < ApplicationRecord
  has_and_belongs_to_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end
end

class Order < ApplicationRecord
  belongs_to :customer, optional: true
  has_many :order_items
  has_many :products, through: :order_items

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at gst hst id order_date pst qst status total_amount updated_at user_id]
  end
end

class Product < ApplicationRecord
  has_one_attached :image

  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :tags

  def self.ransackable_attributes(auth_object = nil)
    %w[brand_id category_id created_at description id name on_sale_status price type_id updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[brand category image_attachment image_blob order_items orders tags type]
  end
end

class Customer < ApplicationRecord
  belongs_to :province

  def self.ransackable_attributes(auth_object = nil)
    %w[email first_name id last_name created_at updated_at]
  end
end

class Province < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at gst hst id name pst qst tax_type updated_at]
  end
end
