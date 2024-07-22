# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# db/seeds.rb
require 'faker'

# Create Planets
10.times do
  Planet.create!(
    name: Faker::Space.planet,
    diameter: Faker::Number.number(digits: 5),
    population: Faker::Number.number(digits: 9)
  )
end

# Create Species
10.times do
  Species.create!(
    name: Faker::Creature::Animal.name,
    average_lifespan: Faker::Number.between(from: 50, to: 1000),
    language: Faker::Lorem.word
  )
end

# Create Films
5.times do
  Film.create!(
    title: Faker::Movie.title,
    episode_id: Faker::Number.between(from: 1, to: 9),
    opening_crawl: Faker::Lorem.paragraph,
    director: Faker::Name.name,
    producer: Faker::Name.name,
    release_date: Faker::Date.backward(days: 365 * 10)
  )
end

# Create Spacecrafts
10.times do
  Spacecraft.create!(
    name: Faker::Vehicle.make_and_model,
    model: Faker::Vehicle.model,
    manufacturer: Faker::Company.name
  )
end

# Create Vehicles
10.times do
  Vehicle.create!(
    name: Faker::Vehicle.make,
    model: Faker::Vehicle.model,
    manufacturer: Faker::Company.name
  )
end

# Create People
50.times do
  person = Person.create!(
    name: Faker::Name.name,
    height: Faker::Number.between(from: 100, to: 200),
    mass: Faker::Number.between(from: 50, to: 100),
    hair_color: Faker::Color.color_name,
    skin_color: Faker::Color.color_name,
    eye_color: Faker::Color.color_name,
    birth_year: Faker::Date.backward(days: 365 * 30).year,
    gender: Faker::Gender.binary_type,
    planet: Planet.order('RANDOM()').first,
    species: Species.order('RANDOM()').first
  )

  # Associate films, spacecrafts, and vehicles
  person.films << Film.order('RANDOM()').limit(3)
  person.spacecrafts << Spacecraft.order('RANDOM()').limit(2)
  person.vehicles << Vehicle.order('RANDOM()').limit(2)
end
