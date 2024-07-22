require 'net/http'
require 'json'
require 'pp'

# Function to fetch and parse JSON data
def fetch_tree_data(url)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

# URL for the subset of the tree data
url = 'https://data.winnipeg.ca/resource/d3jk-hb6j.json'

# Fetch and pretty print the data for inspection
tree_data = fetch_tree_data(url)
pp tree_data.first # Inspect the structure of the first entry to understand the data

# Function to count Ash trees
def count_ash_trees(tree_data)
  ash_tree_count = 0
  tree_data.each do |tree|
    if tree['common_name'] && tree['common_name'].downcase.include?('ash')
      ash_tree_count += 1
    end
  end
  ash_tree_count
end

# Count Ash trees in the subset of tree data
ash_tree_count = count_ash_trees(tree_data)
puts "Number of Ash trees in the subset: #{ash_tree_count}"

# URL for the full tree dataset
full_data_url = 'https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000'

# Fetch the full dataset
full_tree_data = fetch_tree_data(full_data_url)

# Count Ash trees in the full dataset
full_ash_tree_count = count_ash_trees(full_tree_data)
puts "Number of Ash trees in the full dataset: #{full_ash_tree_count}"
