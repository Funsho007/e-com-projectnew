carl  = {
          :toast => 'cosmos',
          :punctuation => [ ',', '.', '?' ],
          :words => [ 'know', 'for', 'we']
        }

sagan = [
          { :are => 'are', 'A' => 'a' },
          { 'waaaaaay' => 'way', :th3 => 'the' },
          'itself',
          { 2 => ['to']}
        ]

puts "#{carl[:words][2].capitalize} #{sagan[0][:are]} #{sagan[0]['A']} #{sagan[1]['waaaaaay']} #{carl[:words][1]} #{carl[:toast]} #{sagan[3][2][0]} #{carl[:words][0]} #{sagan[2]}"

ghosts = [
  { name: "Inky", age: 4, loves: "reindeers", money: 25 },
  { name: "Pinky", age: 5, loves: "garden tools", money: 14 },
  { name: "Blinky", age: 7, loves: "ninjas", money: 18.03 },  # Use a float for decimal amounts
  { name: "Clyde", age: 6, loves: "yarn", money: 0 }
]

puts ghosts

