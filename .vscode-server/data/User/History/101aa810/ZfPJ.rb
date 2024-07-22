class Product < ApplicationRecord
  has_one_attached :image
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items
  has_and_belongs_to_many :tags

  # Define which associations are searchable:
  def self.ransackable_associations(auth_object = nil)
    %w[brand category type tags]
  end

  # Define which attributes are searchable:
  def self.ransackable_attributes(auth_object = nil)
    %w[name price description on_sale_status created_at updated_at]
  end

  validates :name, :price, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :on_sale_status, inclusion: { in: [true, false] }
end
