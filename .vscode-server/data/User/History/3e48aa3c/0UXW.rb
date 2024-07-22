import json
import requests

# Load the subset of tree data
url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json"
response = requests.get(url)
data = json.loads(response.text)

# Function to count Ash trees (considering different types)
def count_ash_trees(trees):
  ash_count = 0
  for tree in trees:
    if "ash" in tree["species"].lower():
      ash_count += 1
  # Add the missing 'end' keyword here
  return ash_count

# Count Ash trees in the subset
ash_count = count_ash_trees(data)
print(f"Number of Ash trees (subset): {ash_count}")

# Load the full tree dataset (might take longer to process)
# url = "https://data.winnipeg.ca/resource/d3jk-hb6j.json?$limit=306000"
# response = requests.get(url)
# full_data = json.loads(response.text)

# Count Ash trees in the full dataset (uncomment if needed)
# ash_count = count_ash_trees(full_data)
# print(f"Number of Ash trees (full): {ash_count}")

