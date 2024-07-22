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

# Single puts statement to build the sentence on separate lines
puts "#{carl[:words][1]} #{sagan[0][:are]} #{carl[:words][2]}"
puts "#{sagan[1]['waaaaaay']} #{sagan[3][2][0]} #{carl[:toast]} #{carl[:punctuation][1]}"
