require 'open-uri'
require 'json'
require 'pp'

# Load the JSON data from the subset of the tree dataset
url = 'https://data.winnipeg.ca/resource/d3jk-hb6j.json'
data = open(url).read

# Parse the JSON data into Ruby data
trees = JSON.parse(data)

# Initialize a counter for Ash trees
ash_tree_count = 0

# Iterate over the array of trees
trees.each do |tree|
  # Check if the common name includes 'Ash'
  if tree['common_name']&.include?('Ash')
    ash_tree_count += 1
  end
end

# Output the number of Ash trees
pp "Total number of Ash trees: #{ash_tree_count}"
