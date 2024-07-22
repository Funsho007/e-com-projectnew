require 'net/http'
require 'json'

url = 'https://data.winnipeg.ca/resource/d3jk-hb6j.json'
uri = URI(url)
response = Net::HTTP.get(uri)
tree_data = JSON.parse(response)

# Initialize a counter for Ash trees
ash_tree_count = 0

# Iterate through each tree in the dataset
tree_data.each do |tree|
  # Check if the common name contains "Ash" or if the genus species contains "Fraxinus"
  if tree['common_name'].to_s.downcase.include?('ash') || tree['genus_species'].to_s.downcase.include?('fraxinus')
    ash_tree_count += 1
  end
end

puts "Number of Ash trees in the dataset: #{ash_tree_count}"
