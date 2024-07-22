# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Ensure the existence of the admin user
if Rails.env.development?
  admin_email = 'admin@example.com'
  unless AdminUser.exists?(email: admin_email)
    AdminUser.create!(email: admin_email, password: 'password', password_confirmation: 'password')
  end
end

require 'faker'

# Ensure products are unique by name to avoid duplicates
10.times do
  product_name = Faker::Commerce.product_name
  unless Product.exists?(name: product_name)
    product = Product.new(
      name: product_name,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      price: Faker::Commerce.price(range: 10.0..100.0),
      stock: Faker::Number.between(from: 1, to: 100)
    )

    # Add a random image from the local filesystem
    product.image.attach(io: File.open(File.join(Rails.root, 'path', 'to', 'your', 'image.jpg')), filename: 'image.jpg')
    product.save!
  end
end