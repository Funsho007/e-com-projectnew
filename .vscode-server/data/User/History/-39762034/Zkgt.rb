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
# Program to calculate the after-tax value of a specific dollar amount and print a message based on the grand total.

# Constants for tax rates
GST_RATE = 0.05 # 5% GST
PST_RATE = 0.07 # 7% PST

# Variable to store the subtotal
sub_total = 5.00 # Example subtotal value

# Calculate taxes
gst = sub_total * GST_RATE
pst = sub_total * PST_RATE

# Calculate grand total
grand_total = sub_total + gst + pst

# Output
puts "Subtotal: $#{'%.2f' % sub_total}"
puts "PST: $#{'%.2f' % pst} - #{(PST_RATE * 100).to_i}%"
puts "GST: $#{'%.2f' % gst} - #{(GST_RATE * 100).to_i}%"
puts "Grand Total: $#{'%.2f' % grand_total}"

# Determine the message based on the grand total
message = if grand_total <= 5
            "Pocket Change"
          elsif grand_total > 5 && grand_total < 20
            "Wallet Time"
          else
            "Charge It!"
          end

# Print the message
puts message
