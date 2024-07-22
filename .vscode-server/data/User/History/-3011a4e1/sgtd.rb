require 'httparty'

# Fetch data from the API
puts "Fetching makeup product data from API..."
response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')
products = response.parsed_response

# Define product categories
puts "Creating product categories..."
categories = {
  'Lipsticks' => ProductCategory.find_or_create_by!(name: 'Lipsticks'),
  'Foundations' => ProductCategory.find_or_create_by!(name: 'Foundations'),
  'Mascaras' => ProductCategory.find_or_create_by!(name: 'Mascaras'),
  'Eyeliners' => ProductCategory.find_or_create_by!(name: 'Eyeliners'),
  'Eye Shadows' => ProductCategory.find_or_create_by!(name: 'Eye Shadows'),
  'Others' => ProductCategory.find_or_create_by!(name: 'Others') # Default category
}

# Clear existing products
puts "Deleting existing products..."
Product.delete_all

# Seed products from API
puts "Creating products from API data..."

products.each do |product_data|
  next unless product_data['category'] # Skip if category is not present in the API data

  # Map API category to your categories
  category_name = case product_data['category']
                  when 'lipstick' then 'Lipsticks'
                  when 'foundation' then 'Foundations'
                  when 'mascara' then 'Mascaras'
                  when 'eyeliner' then 'Eyeliners'
                  when 'eyeshadow' then 'Eye Shadows'
                  else 'Others'
                  end

  # Find or create the category
  category = categories[category_name] || categories['Others']

  # Create or update the product
  category.products.find_or_create_by!(
    name: product_data['name'],
    brand: product_data['brand'],
    price: product_data['price'].to_f,
    description: product_data['description'] || 'No description available',
    image_url: product_data['image_link'] || 'No image available'
  )
end

puts "Seeding completed."
