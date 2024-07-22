require 'json'
require 'net/http'

# Function to count Ash trees
def count_ash_trees(trees)
    ash_count = 0
    trees.each do |tree|
        species = tree["species"]
        if species && species.downcase.include?("ash")
            ash_count += 1
        end
    end
    return ash_count
end

# Load the subset of tree data
url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json"
response = Net::HTTP.get(URI(url))
trees_data = JSON.parse(response)

# Investigate the data using pretty print
puts "Investigating the subset of tree data:"
pp trees_data

# Count Ash trees in the subset
ash_count = count_ash_trees(trees_data)
puts "Number of Ash trees in the subset: #{ash_count}"

# Optionally, you can uncomment the following code to load the full tree dataset and count Ash trees in it
# full_url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000"
# full_response = Net::HTTP.get(URI(full_url))
# full_trees_data = JSON.parse(full_response)
# full_ash_count = count_ash_trees(full_trees_data)
# puts "Number of Ash trees in the full dataset: #{full_ash_count}"

