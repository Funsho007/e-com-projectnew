ActiveAdmin.register OrderItem do
  permit_params :order_id, :product_id, :quantity, :price

  index do
    selectable_column
    id_column
    column :order
    column :product
    column :quantity
    column :price
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :order
      f.input :product
      f.input :quantity
      f.input :price
    end
    f.actions
  end

  show do
    attributes_table do
      row :order
      row :product
      row :quantity
      row :price
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
