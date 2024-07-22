ActiveAdmin.register OrderItem do
  permit_params :order_id, :product_id, :quantity, :price

  form do |f|
    f.inputs 'Order Item Details' do
      f.input :order
      f.input :product
      f.input :quantity
      f.input :price
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :order
    column :product
    column :quantity
    column :price
    actions
  end

  show do
    attributes_table do
      row :order
      row :product
      row :quantity
      row :price
    end
  end
end
