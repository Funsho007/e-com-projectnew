class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    category.products.create!(
  name: product_data['name'],
  brand: product_data['brand'],
  price: product_data['price'].to_f,
  description: product_data['description'] || 'No description available',
  image_url: product_data['image_link'] || 'No image available'
)
rescue => e
  puts "Failed to create product #{product_data['name']}: #{e.message}"
end
end
  end
end
