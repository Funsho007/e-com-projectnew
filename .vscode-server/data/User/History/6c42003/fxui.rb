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
  response = RestClient.get("https://swapi.dev/api/#{endpoint}")
  JSON.parse(response.body)['results']
end

def fetch_random_user_data
  response = RestClient.get("https://randomuser.me/api/")
  JSON.parse(response.body)['results'].first
end

# Seed Planets
fetch_swapi_data('planets').each do |planet|
  planet_name = planet['name']
  planet_id = planet['url'].split('/').last.to_i
  diameter = planet['diameter'].to_i
  population = planet['population'].to_i

  existing_planet = Planet.find_by(name: planet_name)
  if existing_planet
    puts "Planet #{planet_name} already exists, skipping..."
  else
    Planet.create!(
      planet_id: planet_id,
      name: planet_name,
      diameter: diameter,
      population: population
    )
  end
end
# Seed Species
fetch_swapi_data('species').each do |species|
  species_name = species['name']
  species_id = species['url'].split('/').last.to_i

  existing_species = Species.find_by(name: species_name)
  if existing_species
    puts "Species #{species_name} already exists, skipping..."
  else
    Species.create!(
      species_id: species_id,
      name: species_name,
      classification: species['classification'],
      language: species['language']
    )
  end
end

# Seed Films
fetch_swapi_data('films').each do |film|
  film_title = film['title']
  film_id = film['url'].split('/').last.to_i
  release_date = film['release_date']
  opening_crawl = film['opening_crawl']

  existing_film = Film.find_by(title: film_title)
  if existing_film
    puts "Film #{film_title} already exists, skipping..."
  else
    Film.create!(
      film_id: film_id,
      title: film_title,
      release_date: release_date,
      opening_crawl: opening_crawl
    )
  end
end

# Seed Starships
fetch_swapi_data('starships').each do |starship|
  starship_name = starship['name']
  starship_id = starship['url'].split('/').last.to_i
  model = starship['model']
  manufacturer = starship['manufacturer']
  cost_in_credits = starship['cost_in_credits']
  length = starship['length']
  max_atmosphering_speed = starship['max_atmosphering_speed']
  crew = starship['crew']
  passengers = starship['passengers']
  cargo_capacity = starship['cargo_capacity']

  existing_starship = Starship.find_by(name: starship_name)
  if existing_starship
    puts "Starship #{starship_name} already exists, skipping..."
  else
    Starship.create!(
      starship_id: starship_id,
      name: starship_name,
      model: model,
      manufacturer: manufacturer,
      cost_in_credits: cost_in_credits,
      length: length,
      max_atmosphering_speed: max_atmosphering_speed,
      crew: crew,
      passengers: passengers,
      cargo_capacity: cargo_capacity
    )
  end
end
# Seed Vehicles
fetch_swapi_data('vehicles').each do |vehicle|
  vehicle_name = vehicle['name']
  vehicle_id = vehicle['url'].split('/').last.to_i
  model = vehicle['model']
  manufacturer = vehicle['manufacturer']
  cost_in_credits = vehicle['cost_in_credits']
  length = vehicle['length']
  max_atmosphering_speed = vehicle['max_atmosphering_speed']
  crew = vehicle['crew']
  passengers = vehicle['passengers']
  cargo_capacity = vehicle['cargo_capacity']

  existing_vehicle = Vehicle.find_by(name: vehicle_name)
  if existing_vehicle
    puts "Vehicle #{vehicle_name} already exists, skipping..."
  else
    Vehicle.create!(
      vehicle_id: vehicle_id,
      name: vehicle_name,
      model: model,
      manufacturer: manufacturer,
      cost_in_credits: cost_in_credits,
      length: length,
      max_atmosphering_speed: max_atmosphering_speed,
      crew: crew,
      passengers: passengers,
      cargo_capacity: cargo_capacity
    )
  end
end
# Seed People
fetch_swapi_data('people').each do |person|
  person_name = person['name']
  person_id = person['url'].split('/').last.to_i
  birth_year = person['birth_year']
  eye_color = person['eye_color']
  gender = person['gender']
  hair_color = person['hair_color']
  height = person['height']
  mass = person['mass']
  skin_color = person['skin_color']
  homeworld_id = person['homeworld'].split('/').last.to_i
  species_ids = person['species'].map { |species_url| species_url.split('/').last.to_i } if person['species'].present?

  existing_person = Person.find_by(name: person_name)
  if existing_person
    puts "Person #{person_name} already exists, skipping..."
  else
    planet = Planet.find_by(id: homeworld_id)
    species = []

    if species_ids.present?
      species = species_ids.map { |species_id| Species.find_by(id: species_id) }.compact
    end

    if planet && species.any?
      Person.create!(
        person_id: person_id,
        name: person_name,
        birth_year: birth_year,
        eye_color: eye_color,
        gender: gender,
        hair_color: hair_color,
        height: height,
        mass: mass,
        skin_color: skin_color,
        planet: planet,
        species: species
      )
    else
      puts "Skipping #{person_name} because planet or species does not exist"
    end
  end
end
# Seed additional People data from Random User API
10.times do
  random_user_data = fetch_random_user_data
  username = Faker::Internet.username
  email = "#{username}@example.com"
  Person.create!(
    name: "#{random_user_data['name']['first']} #{random_user_data['name']['last']}",
    email: email,
    phone: random_user_data['phone']
  )
end
