ActiveAdmin.register Province do
  config.filters = false

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :tax_type, :gst, :pst, :hst, :qst

  # Form configuration
  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :tax_type, as: :select, collection: ['GST', 'PST', 'HST', 'QST', 'GST+PST'], include_blank: false
      f.input :gst, hint: 'Enter GST rate as a decimal (e.g., 0.05 for 5%)'
      f.input :pst, hint: 'Enter PST rate as a decimal (e.g., 0.07 for 7%)'
      f.input :hst, hint: 'Enter HST rate as a decimal (e.g., 0.13 for 13%)'
      f.input :qst, hint: 'Enter QST rate as a decimal (e.g., 0.09975 for 9.975%)'
    end
    f.actions
  end

  # Index configuration
  index do
    selectable_column
    id_column
    column :name
    column :tax_type
    column :gst
    column :pst
    column :hst
    column :qst
    column :created_at
    column :updated_at
    actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :id
      row :name
      row :tax_type
      row :gst
      row :pst
      row :hst
      row :qst
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
