carl  = {
          :toast => 'cosmos',
          :punctuation => [ ',', '.', '?' ],
          :words => [ 'know', 'for', 'we']
        }

sagan = [
          { :are => 'are', 'A' => 'a' },
          { 'waaaaaay' => 'way', :th3 => 'the' },
          'itself.',
          { 2 => ['to']}
        ]

puts "#{carl[:words][2].capitalize} #{sagan[0][:are]} #{sagan[0]['A']}
 #{sagan[1]['waaaaaay']} #{carl[:words][1]} #{carl[:toast]} #{sagan[3][2][0]} #{carl[:words][0]} #{sagan[2]}"

ghosts = [
  { name: 'Inky', age: 4, loves: 'reindeers', net_worth: 25 },
  { name: 'Pinky', age: 5, loves: 'garden tools', net_worth: 14 },
  { name: 'Blinky', age: 7, loves: 'ninjas', net_worth: 18.03 },
  { name: 'Clyde', age: 6, loves: 'yarn', net_worth: 0 }
]

ghosts.each do |ghost|
  ghost_info  = "#{ghost[:name]} is #{ghost[:age]} years old, "
  ghost_info += "loves #{ghost[:loves]} and "
  ghost_info += "has #{ghost[:net_worth]} dollars in the bank."
  puts ghost_info
end

require 'net/http'
require 'json'

url = 'https://dog.ceo/api/breeds/list/all'
uri = URI(url)
response = Net::HTTP.get(uri)
dog_breeds = JSON.parse(response)

# Iterate through each breed and sub-breed
dog_breeds['message'].each do |breed, sub_breeds|
  puts "* #{breed.capitalize}"
  sub_breeds.each do |sub_breed|
    puts "  * #{sub_breed.capitalize}" if sub_breeds.any?
  end
end
