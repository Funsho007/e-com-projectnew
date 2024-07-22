ActiveAdmin.register Province do
  permit_params :name, :tax_type, :gst, :pst, :hst

  form do |f|
    f.inputs 'Province Details' do
      f.input :name
      f.input :tax_type
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :tax_type
    column :gst
    column :pst
    column :hst
    actions
  end

  show do
    attributes_table do
      row :name
      row :tax_type
      row :gst
      row :pst
      row :hst
    end
  end
end
