ActiveAdmin.register Order do
  permit_params :order_date, :gst, :pst, :hst, :qst, :total_amount, :status, :customer_id

  index do
    selectable_column
    id_column
    column :customer
    column :order_date
    column :gst
    column :pst
    column :hst
    column :qst
    column :total_amount
    column :status
    column :created_at
    column :updated_at
    actions
  end

  filter :customer
  filter :order_date
  filter :gst
  filter :pst
  filter :hst
  filter :qst
  filter :total_amount
  filter :status
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :customer
      f.input :order_date
      f.input :gst
      f.input :pst
      f.input :hst
      f.input :qst
      f.input :total_amount
      f.input :status
    end
    f.actions
  end

  show do
    attributes_table do
      row :customer
      row :order_date
      row :gst
      row :pst
      row :hst
      row :qst
      row :total_amount
      row :status
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end

