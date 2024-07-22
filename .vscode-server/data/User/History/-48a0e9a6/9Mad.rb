ActiveAdmin.register Province do
  permit_params :name, :tax_type, :GST, :PST, :HST

  # Adding filters
  filter :name
  filter :tax_type
  filter :GST
  filter :PST
  filter :HST
  filter :created_at
  filter :updated_at

  # If you need to filter by customer attributes, make sure to specify the correct join
  filter :customers, as: :select, collection: -> { Customer.all.collect { |customer| [customer.full_name, customer.id] } }

  index do
    selectable_column
    id_column
    column :name
    column :tax_type
    column :GST
    column :PST
    column :HST
    column :created_at
    column :updated_at
    actions
  end
end
