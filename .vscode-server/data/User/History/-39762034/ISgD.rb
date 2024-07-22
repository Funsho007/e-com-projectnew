#

# Store a dollar amount in a variable called "sub_total"
GST_RATE = 0.05 # 5% GST rate
PST_RATE = 0.07 # 7% PST rate

# Store a dollar amount in a variable called "sub_total"
sub_total = 5.00

# Calculate GST and PST
gst = sub_total * GST_RATE
pst = sub_total * PST_RATE

# Calculate and store the after tax amount in a variable called "grand_total"
grand_total = sub_total + gst + pst

# Generate output to the screen
puts "Subtotal: $#{'%.2f' % sub_total}"
puts "PST: $#{'%.2f' % pst} - #{(PST_RATE * 100).to_i}%"
puts "GST: $#{'%.2f' % gst} - #{(GST_RATE * 100).to_i}%"
puts "Grand Total: $#{'%.2f' % grand_total}"

# Update your Ruby program from question one such that it prints a short message after the grand total.



# Store the dollar amount in a variable
sub_total = 5.00


# Calculate the GST and PST amounts
gst_amount = sub_total * GST_RATE
pst_amount = sub_total * PST_RATE

# Calculate the grand total
grand_total = sub_total + gst_amount + pst_amount

# Print the breakdown of the amounts
puts "Subtotal: $#{'%.2f' % sub_total}"
puts "PST: $#{'%.2f' % pst_amount} - #{(PST_RATE * 100).to_i}%"
puts "GST: $#{'%.2f' % gst_amount} - #{(GST_RATE * 100).to_i}%"
puts "Grand Total: $#{'%.2f' % grand_total}"

# Determine the message based on the grand total
if grand_total <= 5
  "Pocket Change"
elsif grand_total > 5 && grand_total < 20
  "Wallet Time"
else
  "Charge It!"
end

#Do some research online to figure out how to read keyboard input from Ruby and how to convert strings into floats.
puts "Please enter the subtotal:"
subtotal = gets.chomp.to_f

tax_rate = 0.06
tax = subtotal * tax_rate
total = subtotal + tax

puts "Subtotal: $#{subtotal}"
puts "Tax: $#{tax}"
puts "Total: $#{total}"
