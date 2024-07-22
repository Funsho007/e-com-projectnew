require 'json'
require 'rest-client'

# Load the subset of tree data (faster for testing)
url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000"
response = RestClient.get(url)
data = JSON.parse(response.body)

# Function to count Ash trees (considering different types)
def count_ash_trees(trees)
  ash_count = 0
  trees.each do |tree|
    ash_count += 1 if tree["species"].downcase.include?("ash")
  end
  ash_count
end

# Count Ash trees in the subset
ash_count = count_ash_trees(data)
puts "Number of Ash trees (subset): #{ash_count}"

# Load the full tree dataset (might take longer to process)
# url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000"
# response = RestClient.get(url)
# full_data = JSON.parse(response.body)

# Count Ash trees in the full dataset (uncomment if needed)
# ash_count = count_ash_trees(full_data)
# puts "Number of Ash trees (full): #{ash_count}"
