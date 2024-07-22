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
          # Access data using hash keys and array indexing
words = carl[:words]
punctuation = carl[:punctuation].sample
way = sagan[1]['waaaaaay']
to = sagan[3][2].first

# Build the sentence with string interpolation
puts "We #{words[1]} #{way} #{words[0]} #{carl[:toast]} #{to} know itself#{punctuation}"

# Single puts statement to build the sentence on a single line with proper spacing
puts "#{carl[:words][2]} #{sagan[0][:are]} #{sagan[1]['waaaaaay']} #{sagan[3][2][0]} #{carl[:toast]} #{carl[:punctuation][1]}"
