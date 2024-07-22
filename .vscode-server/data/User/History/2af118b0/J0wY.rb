# app/models/brand.rb
class Brand < ApplicationRecord
  has_many :products
end

# app/models/type.rb

  has_many :products
end

# app/models/category.rb

  has_many :products
end

# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :brand
  belongs_to :type
  belongs_to :category
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :orders
  has_many :order_items
end

# app/models/tag.rb
class Tag < ApplicationRecord
  has_and_belongs_to_many :products
end

# app/models/user.rb
class User < ApplicationRecord
  belongs_to :province
  has_many :orders
end

# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :products
  has_many :order_items
end

# app/models/province.rb
class Province < ApplicationRecord
  has_many :users
end

# app/models/order_item.rb
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
end
def self.ransackable_associations(auth_object = nil)
  ["products"]
end
