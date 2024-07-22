require 'net/http'
require 'json'
require 'pp'

def load_data(url)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  JSON.parse(response)
end

subset_url = 'https://data.winnipeg.ca/resource/d3jk-hb6j.json'
full_url = 'https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000'

# Load subset of tree data
tree_data_subset = load_data(subset_url)

# Investigate the data using pretty print
pp tree_data_subset

# Function to count Ash trees
def count_ash_trees(tree_data)
  ash_count = 0
  tree_data.each do |tree|
    if tree['common_name']&.downcase&.include?('ash')
      ash_count += 1
    end
  end
  ash_count
end

# Count Ash trees in the subset of tree data
ash_count_subset = count_ash_trees(tree_data_subset)
puts "Number of Ash trees in the subset dataset: #{ash_count_subset}"

# Load full tree data
tree_data_full = load_data(full_url)

# Count Ash trees in the full tree data
ash_count_full = count_ash_trees(tree_data_full)
puts "Number of Ash trees in the full dataset: #{ash_count_full}"
