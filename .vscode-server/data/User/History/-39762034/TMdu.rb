# Function to calculate the wallet message based on grand total
def calculate_wallet_message(grand_total)
  if grand_total <= 5.00
    "Pocket Change"
  elsif grand_total > 5.00 && grand_total < 20.00
    "Wallet Time"
  else
    "Charge It!"
  end
end

# Store a dollar amount in a variable called "sub_total"
print "Enter the subtotal: "
sub_total = gets.chomp.to_f

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
puts "Wallet Message: #{calculate_wallet_message(grand_total)}"
