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

require 'faker'
10.times do
  product = Product.new(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Commerce.price(range: 10.0..100.0),
    stock: Faker::Number.between(from: 1, to: 100)
  )

  # Add a random image from the local filesystem
  product.image.attach(io: File.open(File.join(Rails.root, 'path', 'to', 'your', 'image.jpg')), filename: 'image.jpg')
  product.save!
end
