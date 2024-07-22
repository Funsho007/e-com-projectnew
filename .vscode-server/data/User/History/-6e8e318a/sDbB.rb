require 'httparty'
require 'json'

# Fetch data from the API
puts "Fetching product data from API..."
response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')
products = response.parsed_response

# Define product categories if needed
puts "Creating product categories..."
categories = {
  'Game Products' => ProductCategory.find_or_create_by!(name: 'Game Products'),
  'Playstations' => ProductCategory.find_or_create_by!(name: 'Playstations'),
  'Xboxes' => ProductCategory.find_or_create_by!(name: 'Xboxes'),
  'Cables and wire' => ProductCategory.find_or_create_by!(name: 'Cables and wire')
}

# Clear existing products
puts "Deleting existing products..."
Product.delete_all

# Seed products from API
puts "Creating products from API data..."

products.each do |product_data|
  category = categories[product_data['category']] || categories['Game Products'] # Default to 'Game Products' if category is not found

  category.products.create!(
    name: product_data['name'],
    brand: product_data['brand'],
    price: product_data['price'].to_f,
    description: product_data['description'] || 'No description available',
    image_url: product_data['image_link'] || 'No image available'
  )
end

puts "Seeding completed."
