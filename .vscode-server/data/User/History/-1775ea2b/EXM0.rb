ActiveAdmin.register Order do
  permit_params :user_id, :order_date, :gst, :pst, :hst, :total_amount, :status, order_items_attributes: [:id, :product_id, :quantity, :price, :_destroy]

  form do |f|
    f.inputs 'Order Details' do
      f.input :user
      f.input :order_date
      f.input :gst
      f.input :pst
      f.input :hst
      f.input :total_amount
      f.input :status
    end
    f.inputs 'Order Items' do
      f.has_many :order_items, allow_destroy: true do |item|
        item.input :product
        item.input :quantity
        item.input :price
      end
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :user
    column :order_date
    column :total_amount
    column :status
    actions
  end

  show do
    attributes_table do
      row :user
      row :order_date
      row :gst
      row :pst
      row :hst
      row :total_amount
      row :status
    end
    panel "Order Items" do
      table_for order.order_items do
        column :product
        column :quantity
        column :price
      end
    end
  end
end
