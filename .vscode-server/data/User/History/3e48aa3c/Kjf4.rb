require 'json'
require 'net/http'

# Load the subset of tree data
 url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000"

response = Net::HTTP.get(URI(url))
data = JSON.parse(response)

# Function to count Ash trees (considering different types)
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

# Count Ash trees in the subset
ash_count = count_ash_trees(data)
puts "Number of Ash trees in the subset: #{ash_count}"
