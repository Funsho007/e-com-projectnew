# Author: [Your Name]

# Store a dollar amount in a variable called "sub_total"
sub_total = 5.00

# Store the GST rate and PST rate in constants
GST_RATE = 0.05
PST_RATE = 0.07

# Calculate PST and GST amounts
pst_amount = sub_total * PST_RATE
gst_amount = sub_total * GST_RATE

# Calculate the after tax amount
grand_total = sub_total + pst_amount + gst_amount

# Generate output to the screen
puts "Subtotal: $#{sub_total}"
puts "PST: $#{pst_amount.round(2)} - #{(PST_RATE * 100).to_i}%"
puts "GST: $#{gst_amount.round(2)} - #{(GST_RATE * 100).to_i}%"
puts "Grand Total: $#{grand_total.round(2)}"
