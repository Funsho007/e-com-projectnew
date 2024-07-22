ActiveAdmin.register Brand do
  permit_params :name

  form do |f|
    f.inputs 'Brand Details' do
      f.input :name
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  show do
    attributes_table do
      row :name
    end
  end
end
