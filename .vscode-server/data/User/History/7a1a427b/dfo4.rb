require 'net/http'
require 'json'
require 'pp'

url = 'https://dog.ceo/api/breeds/list/all'
uri = URI(url)
response = Net::HTTP.get(uri)
dog_breeds = JSON.parse(response) # Convert JSON data into Ruby data.
pp dog_breeds # pp stands for pretty print.

# Based on the inspected JSON structure, we'll write the nested loop
breeds = dog_breeds["message"]

breeds.each do |breed, sub_breeds|
  if sub_breeds.empty?
    puts breed
  else
    sub_breeds.each do |sub_breed|
      puts "#{breed} - #{sub_breed}"
    end
  end
end
