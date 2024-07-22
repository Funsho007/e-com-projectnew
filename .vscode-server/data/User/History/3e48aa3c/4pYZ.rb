require 'json'
require 'net/http'

# Load the subset of tree data
url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json"
response = Net::HTTP.get(URI(url))
data = JSON.parse(response)

# Function to count Ash trees (considering different types)
def count_ash_trees(trees)
    ash_count = 0
    trees.each do |tree|
        if tree["species"].downcase.include?("ash")
            ash_count += 1
        end
    end
    # Added 'end' keyword
    return ash_count
end

# Count Ash trees in the subset
ash_count = count_ash_trees(data)
puts "Number of Ash trees (subset): #{ash_count}"

# print(f"Number of Ash trees (full): {ash_count}")
