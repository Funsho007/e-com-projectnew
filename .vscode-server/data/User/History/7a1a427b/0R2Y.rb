require 'net/http'
require 'json'

url = 'https://dog.ceo/api/breeds/list/all'
uri = URI(url)
response = Net::HTTP.get(uri)
dog_breeds_data = JSON.parse(response)

# Extract breeds and sub-breeds
breeds = dog_breeds_data["message"]

# Print out the list of breeds and sub-breeds
puts "List of Dog Breeds and Sub-breeds:"
breeds.each do |breed, sub_breeds|
  if sub_breeds.empty?
    puts "* #{breed.capitalize}"
  else
    puts "* #{breed.capitalize}:"
    sub_breeds.each do |sub_breed|
      puts "  * #{sub_breed.capitalize}"
    end
  end
end
