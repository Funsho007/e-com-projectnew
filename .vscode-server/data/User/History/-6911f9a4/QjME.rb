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
    image_path = Rails.root.join('seed_images', 'example.jpg')
    product.image.attach(io: File.open(image_path), filename: 'example.jpg')
    product.save!
  end
end
