# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'httparty'
require 'faker'
require 'open-uri'
require 'net/http'

OrderItem.destroy_all
Order.destroy_all
Customer.destroy_all

# Delete existing images
Product.all.each do |product|
  product.image.purge_later
end

Product.destroy_all
Brand.destroy_all
Category.destroy_all
Type.destroy_all
Tag.destroy_all
Province.destroy_all

# Fetch data from the Makeup API
response = HTTParty.get('http://makeup-api.herokuapp.com/api/v1/products.json')

# Extract necessary data for brands, categories, products, and tags
products_data = response.parsed_response

brands = products_data.map { |product| product['brand'] }.uniq
categories = products_data.map { |product| product['category'] }.uniq
tags = products_data.flat_map { |product| product['tag_list'] }.uniq
types = products_data.map { |product| product['product_type'] }.uniq

# Seed Brands
brands.each do |brand_name|
  Brand.find_or_create_by(name: brand_name)
end

# Seed Categories
categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

# Seed Types
types.each do |type_name|
  Type.find_or_create_by(name: type_name)
end

# Seed Products, Tags, and Product-Tags
products_data.first(200).each do |product_data|
  brand = Brand.find_or_create_by(name: product_data['brand'])
  category = Category.find_or_create_by(name: product_data['category'])
  type = Type.find_or_create_by(name: product_data['product_type'])

  price = product_data['price'].to_f

  # Check if the price is 0
  if price.zero?
    # Generate a random price using Faker
    random_price = Faker::Commerce.price(range: 0..100.0)

    # Assign the random price to the product
    product_data['price'] = random_price
  end

  # Generate a random boolean value for on_sale_status
  on_sale = [true, false].sample

  product = Product.find_or_create_by(
    name: product_data['name'],
    brand_id: brand.id,
    category_id: category.id,
    type_id: type.id,
    price: product_data['price'].to_f,
    description: product_data['description'],
    on_sale_status: on_sale,
    created_at: product_data['created_at'],
    updated_at: product_data['updated_at']
  )
# db/seeds.rb
Product.create!(name: 'Lipstick', description: 'A beautiful red lipstick', price: 19.99)
Product.create!(name: 'Foundation', description: 'A smooth foundation', price: 29.99)
# Add more products as needed...

  # Attach image using Faker
  image_url = Faker::LoremFlickr.image(size: "800x600", search_terms: ['makeup'])
  image_io = URI.open(image_url)
  product.image.attach(
    io: image_io,
    filename: "product_#{product.id}.jpg",
    content_type: 'image/jpeg'
  )

  # Seed Tags and Product-Tags
  tag_names = product_data['tag_list']
  tags = tag_names.map do |tag_name|
    Tag.find_or_create_by(name: tag_name)
  end
  product.tags << tags
end

# Seed Provinces with Canadian tax rates
provinces_data = [
  { name: 'Alberta', tax_type: 'GST', gst: 0.05, pst: 0, hst: 0 },
  { name: 'British Columbia', tax_type: 'GST+PST', gst: 0.05, pst: 0.05, hst: 0 },
  { name: 'Manitoba', tax_type: 'GST+PST', gst: 0.05, pst: 0.07, hst: 0 },
  { name: 'New Brunswick', tax_type: 'HST', gst: 0, pst: 0, hst: 0.15 },
  { name: 'Newfoundland and Labrador', tax_type: 'HST', gst: 0, pst: 0, hst: 0.15 },
  { name: 'Northwest Territories', tax_type: 'GST', gst: 0.05, pst: 0, hst: 0 },
  { name: 'Nova Scotia', tax_type: 'HST', gst: 0, pst: 0, hst: 0.15 },
  { name: 'Nunavut', tax_type: 'GST', gst: 0.05, pst: 0, hst: 0 },
  { name: 'Ontario', tax_type: 'HST', gst: 0, pst: 0, hst: 0.13 },
  { name: 'Prince Edward Island', tax_type: 'HST', gst: 0, pst: 0, hst: 0.15 },
  { name: 'Quebec', tax_type: 'GST+PST', gst: 0.05, pst: 0.09975, hst: 0 },
  { name: 'Saskatchewan', tax_type: 'GST+PST', gst: 0.05, pst: 0.06, hst: 0 },
  { name: 'Yukon', tax_type: 'GST', gst: 0.05, pst: 0, hst: 0 }
]
provinces_data.each do |province_data|
  Province.create(province_data)
end

# Create AdminUser if not exists
AdminUser.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end

# Page.create(title: "Contact", content: "This is the contact page content.")
# Page.create(title: "About", content: "This is the about page content.")
