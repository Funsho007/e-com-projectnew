# carl = { first_name: "Carl", last_name: "Sagan" }
# sagan = ["We", "are", "a", "way", "for", "the", "cosmos", "to", "know", "itself."]

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



puts "#{sagan[0]} #{sagan[1]} #{sagan[2]} #{sagan[3]} #{sagan[4]} #{sagan[5]} #{sagan[6]} #{sagan[7]} #{sagan[8]} #{sagan[9]}"
