# class ProductCategory < ApplicationRecord
#   has_many :products

#   def self.ransackable_attributes(auth_object = nil)
#     ["created_at", "description", "id", "name", "updated_at"]
#   end
#   def self.ransackable_associations(auth_object = nil)
#     ["products"]
#   end
# end


# In Rails console

# Find the category you want to delete
category = ProductCategory.find_by(id: your_category_id)

# Ensure the category exists
if category
  # Delete associated products
  category.products.destroy_all

  # Now delete the category
  category.destroy
else
  puts "Category not found"
end
