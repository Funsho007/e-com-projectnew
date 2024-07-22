require 'faker'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Create Brands
10.times do
  Brand.create!(name: Faker::Company.name)
end

# Create Types
10.times do
  Type.create!(name: Faker::Commerce.department)
end

# Create Categories
10.times do
  Category.create!(name: Faker::Commerce.material)
end

# Create Tags
10.times do
  Tag.create!(name: Faker::Commerce.promotion_code)
end

# Create Provinces
Province.create!([
  { name: 'Alberta', tax_type: 'GST', gst: 5.0, pst: 0.0, hst: 0.0 },
  { name: 'British Columbia', tax_type: 'GST+PST', gst: 5.0, pst: 7.0, hst: 0.0 },
  # Add other provinces similarly...
])

# Create Users
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password',
    password_confirmation: 'password',
    province: Province.order('RANDOM()').first
  )
end

# Create Products
100.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    brand: Brand.order('RANDOM()').first,
    type: Type.order('RANDOM()').first,
    category: Category.order('RANDOM()').first,
    price: Faker::Commerce.price(range: 10.0..100.0),
    description: Faker::Lorem.paragraph,
    on_sale_status: [true, false].sample
  )

  # Attach an image to the product
  product.image.attach(io: File.open(Rails.root.join('path/to/your/image.jpg')), filename: 'image.jpg')

  # Add tags to the product
  product.tags << Tag.order('RANDOM()').limit(3)
end

# Create Orders
10.times do
  order = Order.create!(
    user: User.order('RANDOM()').first,
    order_date: Faker::Date.backward(days: 30),
    gst: 5.0,
    pst: 7.0,
    hst: 0.0,
    total_amount: Faker::Commerce.price(range: 100.0..1000.0),
    status: ['new', 'paid', 'shipped'].sample
  )

  # Create OrderItems for each order
  3.times do
    OrderItem.create!(
      order: order,
      product: Product.order('RANDOM()').first,
      quantity: rand(1..5),
      price: Faker::Commerce.price(range: 10.0..100.0)
    )
  end
end
