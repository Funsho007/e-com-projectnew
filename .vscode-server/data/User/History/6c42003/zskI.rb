# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'rest-client'
require 'json'
require 'faker'

def fetch_swapi_data(endpoint)
  results = []
  url = "https://swapi.dev/api/#{endpoint}/"
  while url
    response = RestClient.get(url)
    data = JSON.parse(response.body)
    results.concat(data['results'])
    url = data['next']
  end
  results
end

# Seed Planets
planets_data = fetch_swapi_data('planets')
planets_data.each do |planet|
  Planet.create!(
    planet_id: planet['url'].split('/').last.to_i,
    name: planet['name'],
    diameter: planet['diameter'].to_i,
    population: planet['population'].to_i
  )
end

# Seed Species
species_data = fetch_swapi_data('species')
species_data.each do |species|
  Species.create!(
    species_id: species['url'].split('/').last.to_i,
    name: species['name'],
    average_lifespan: species['average_lifespan'].to_i,
    language: species['language']
  )
end

# Seed Films
# films_data = fetch_swapi_data('films')
# films_data.each do |film|
#   Film.create!(
#     film_id: film['url'].split('/').last.to_i,
#     title: film['title'],
#     episode_id: film['episode_id'].to_i,
#     opening_crawl: film['opening_crawl'],
#     director: film['director'],
#     producer: film['producer'],
#     release_date: film['release_date']
#   )
# end

# Seed Starships
# starships_data = fetch_swapi_data('starships')
# starships_data.each do |starship|
#   Starship.create!(
#     starship_id: starship['url'].split('/').last.to_i,
#     name: starship['name'],
#     model: starship['model'],
#     manufacturer: starship['manufacturer']
#   )
# end

# Seed Vehicles
# vehicles_data = fetch_swapi_data('vehicles')
# vehicles_data.each do |vehicle|
#   Vehicle.create!(
#     vehicle_id: vehicle['url'].split('/').last.to_i,
#     name: vehicle['name'],
#     model: vehicle['model'],
#     manufacturer: vehicle['manufacturer']
#   )
# end

# Seed People
people_data = fetch_swapi_data('people')
people_data.each do |person|
  species_id = person['species'][0]&.split('/')&.last&.to_i  # Handle nil gracefully
  Person.create!(
    person_id: person['url'].split('/').last.to_i,
    name: person['name'],
    height: person['height'].to_i,
    mass: person['mass'].to_i,
    hair_color: person['hair_color'],
    skin_color: person['skin_color'],
    eye_color: person['eye_color'],
    birth_year: person['birth_year'],
    gender: person['gender'],
    planet_id: person['homeworld'].split('/').last.to_i,
    specie_id: species_id,
    species_id: species_id
  )
end

# Seed additional data with Faker
10.times do
  # planet = Planet.create!(
  #   name: Faker::Space.planet,
  #   diameter: Faker::Number.number(digits: 5),
  #   population: Faker::Number.number(digits: 7)
  # )

  # species = Species.create!(
  #   name: Faker::Games::Pokemon.name,
  #   average_lifespan: Faker::Number.number(digits: 3),
  #   language: Faker::Games::Pokemon.location
  # )

  # person = Person.create!(
  #   name: Faker::Name.name,
  #   height: Faker::Number.between(from: 150, to: 200),
  #   mass: Faker::Number.between(from: 50, to: 100),
  #   hair_color: Faker::Color.color_name,
  #   skin_color: Faker::Color.color_name,
  #   eye_color: Faker::Color.color_name,
  #   birth_year: Faker::Date.birthday(min_age: 20, max_age: 60).year.to_s,
  #   gender: Faker::Gender.binary_type,
  #   planet: planet,
  #   species: species
  # )


    films = Film.create!(
      title: Faker::Movie.title,
      episode_id: Faker::Number.between(from: 1, to: 9),
      opening_crawl: Faker::Lorem.paragraph,
      director: Faker::Name.name,
      producer: Faker::Name.name,
      release_date: Faker::Date.between(from: '1977-05-25', to: '2019-12-20')
    )


    starships = Starship.create!(
      name: Faker::Space.nasa_space_craft,
      model: Faker::Vehicle.make_and_model,
      manufacturer: Faker::Company.name
    )

    vehicles = Vehicle.create!(
      name: Faker::Vehicle.make_and_model,
      model: Faker::Vehicle.model,
      manufacturer: Faker::Company.name
    )
end
