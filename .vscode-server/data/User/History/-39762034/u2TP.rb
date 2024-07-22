# Author: [Your Name]

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
puts "Subtotal: $#{sub_total}"
puts "PST: $#{pst_amount.round(2)} - #{(PST_RATE * 100).to_i}%"
puts "GST: $#{gst_amount.round(2)} - #{(GST_RATE * 100).to_i}%"
puts "Grand Total: $#{grand_total.round(2)}"
