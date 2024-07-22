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
  {name: 'Inky', age: 4, loves: 'reindeers', bank: 25},
  {name: 'Pinky', age: 5, loves: 'garden tools', bank: 14},
  {name: 'Blinky', age: 7, loves: 'ninjas', bank: 18.03},
  {name: 'Clyde', age: 6, loves: 'yarn', bank: 0}
]
ghosts.each do |ghost|
  puts "#{ghost[:name]} is # {ghost[:age]} years old, loves #
  {ghost[:loves]} and has #{'%.2f'% ghost[:bank]} dollar in the bank."
end
