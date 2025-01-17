ActiveAdmin.register_page 'Orders Summary' do
  content title: 'Orders Summary' do
    Customer.joins(orders: :order_items).distinct.each do |customer|
      panel "Orders for Customer #{customer.id} - #{customer.first_name} #{customer.last_name}" do
        table_for customer.orders do
          column 'Order ID', sortable: 'orders.id' do |order|
            order.id
          end
          column 'Date' do |order|
            order.order_date
          end
          column 'Products Ordered' do |order|
            order.order_items.joins(:product).pluck('order_items.quantity', 'products.name').map { |quantity, name| "#{quantity} x #{name}" }.join(', ')
          end
          column 'HST' do |order|
            number_to_currency(order.hst)
          end
          column 'PST' do |order|
            number_to_currency(order.pst)
          end
          column 'GST' do |order|
            number_to_currency(order.gst)
          end
          column 'Order Total' do |order|
            number_to_currency(order.total_amount)
          end
          column 'Order Status' do |order|
            order.status
          end
        end
      end
    end
  end
end
