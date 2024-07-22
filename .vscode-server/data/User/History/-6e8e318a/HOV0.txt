# #Admin User Creation
# # user = User.create(first_name: "test", last_name: "admin", email: "admin@UniMart.com", password: "Admin123", phone_number: "000000000", address: "xyz")
# # user.add_role(:admin)
# #
# #AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

# require 'faker'

# puts "Game Categories Creation ..."
# cat1 = ProductCategory.find_or_create_by! name: 'Game Products'
# cat2 = ProductCategory.find_or_create_by! name: 'Playstations'
# cat3 = ProductCategory.find_or_create_by! name: 'Xboxes'
# cat4 = ProductCategory.find_or_create_by! name: 'Cables and wire'

# def open_asset(file_name)
#   File.open(Rails.root.join('db', 'seed_images', file_name))
# end

# puts "Products Creation ..."

# Product.destroy_all

# cat1.products.create!({
#                         name:  'Xbox Wireless Controller',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('5.jpg'),
#                         price: 70.99,
#                         quantity: 10
#                       })

# cat3.products.create!({
#                         name:  'Playstation Controller',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('2.jpeg'),
#                         price: 100.99,
#                         quantity: 10
#                       })


# cat2.products.create!({
#                         name:  "Playstation",
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('2.jpeg'),
#                         quantity: 16,
#                         price: 15.49
#                       })

# cat4.products.create!({
#                         name:  'Xbox',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('9.jpeg'),
#                         quantity: 18,
#                         price: 26.00
#                       })

# cat4.products.create!({
#                         name:  'Console',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('5.jpg'),
#                         quantity: 29,
#                         price: 200.29
#                       })
# cat2.products.create!({
#                         name:  'Controller',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('8.jpeg'),
#                         quantity: 10,
#                         price: 30.00
#                       })
# cat4.products.create!({
#                         name:  'Game',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('7.jpeg'),
#                         quantity: 10,
#                         price: 70.99
#                       })

# cat4.products.create!({
#                         name:  'Console Game 1',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('9.jpeg'),
#                         price: 3_052.00,
#                         quantity: 10
#                       })

# cat4.products.create!({
#                         name:  'Console Game 2',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('7.jpeg'),
#                         price: 987.65,
#                         quantity: 10
#                       })
# cat4.products.create!({
#                         name:  'Playstation 3',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('8.jpeg'),
#                         price: 987.65,
#                         quantity: 10
#                       })
# cat4.products.create!({
#                         name:  'Xbox Wire',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('5.jpg'),
#                         price: 300.29,
#                         quantity: 40
#                       })
# cat4.products.create!({
#                         name:  'Xbox 2',
#                         description: Faker::Hipster.paragraph,
#                         image: open_asset('7.jpeg'),
#                         price: 800.99,
#                         quantity: 80
#                       })
