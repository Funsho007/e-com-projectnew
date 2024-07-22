# db/seeds.rb
AdminUser.create!(email: "adminlog#{SecureRandom.hex}@example.com", password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'httparty'
require 'faker'
require 'open-uri'

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
products_data = response.parsed_response

# Extract necessary data for brands, categories, products, and tags
brands = products_data.map { |product| product['brand'] }.uniq
categories = products_data.map { |product| product['category'] }.uniq
tags = products_data.flat_map { |product| product['tag_list'] }.uniq.compact
types = products_data.map { |product| product['product_type'] }.uniq

# Seed Brands
brands.each { |brand_name| Brand.find_or_create_by(name: brand_name) }

# Seed Categories
categories.each { |category_name| Category.find_or_create_by(name: category_name) }

# Seed Types
types.each { |type_name| Type.find_or_create_by(name: type_name) }

# Seed Products, Tags, and Product-Tags
products_data.first(200).each do |product_data|
  brand = Brand.find_by(name: product_data['brand'])
  category = Category.find_by(name: product_data['category'])
  type = Type.find_by(name: product_data['product_type'])

  price = product_data['price'].to_f
  price = Faker::Commerce.price(range: 0..100.0) if price.zero?

  # Generate a random boolean value for on_sale_status
  on_sale = [true, false].sample

  product = Product.create!(
    name: product_data['name'],
    brand: brand,
    category: category,
    type: type,
    price: price,
    description: product_data['description'],
    on_sale_status: on_sale,
    created_at: product_data['created_at'],
    updated_at: product_data['updated_at']
  )

  # Attach image if available
  begin
    unsplash_image_name = URI.encode_www_form_component(product_data['name'])
    unsplash_image_url = "https://source.unsplash.com/800x600/?#{unsplash_image_name}"
    image_io = URI.open(unsplash_image_url)
    product.image.attach(
      io: image_io,
      filename: "product_#{product.id}.jpg",
      content_type: 'image/jpeg'
    )
  rescue OpenURI::HTTPError
    puts "Failed to retrieve image from Unsplash for product: #{product_data['name']}"
  end

  # Seed Tags and Product-Tags
  tag_names = product_data['tag_list'] || []
  tags = tag_names.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
  product.tags << tags
end

# Seed Provinces with Canadian tax rates
provinces_data = [
  { name: 'Alberta', tax_type: 'GST', GST: 0.05, PST: 0, HST: 0 },
  { name: 'British Columbia', tax_type: 'GST+PST', GST: 0.05, PST: 0.05, HST: 0 },
  { name: 'Manitoba', tax_type: 'GST+PST', GST: 0.05, PST: 0.07, HST: 0 },
  { name: 'New Brunswick', tax_type: 'HST', GST: 0, PST: 0, HST: 0.15 },
  { name: 'Newfoundland and Labrador', tax_type: 'HST', GST: 0, PST: 0, HST: 0.15 },
  { name: 'Northwest Territories', tax_type: 'GST', GST: 0.05, PST: 0, HST: 0 },
  { name: 'Nova Scotia', tax_type: 'HST', GST: 0, PST: 0, HST: 0.15 },
  { name: 'Nunavut', tax_type: 'GST', GST: 0.05, PST: 0, HST: 0 },
  { name: 'Ontario', tax_type: 'HST', GST: 0, PST: 0, HST: 0.13 },
  { name: 'Prince Edward Island', tax_type: 'HST', GST: 0, PST: 0, HST: 0.15 },
  { name: 'Quebec', tax_type: 'GST+PST', GST: 0.05, PST: 0.09975, HST: 0 },
  { name: 'Saskatchewan', tax_type: 'GST+PST', GST: 0.05, PST: 0.06, HST: 0 },
  { name: 'Yukon', tax_type: 'GST', GST: 0.05, PST: 0, HST: 0 }
]

provinces_data.each { |province_data| Province.create!(province_data) }
