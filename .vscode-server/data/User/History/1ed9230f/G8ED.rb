ActiveAdmin.register Species do
  index do
    selectable_column
    id_column
    column :name
    column :classification
    column :designation
    column :average_height
    column :average_lifespan
    column :language
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :classification
      row :designation
      row :average_height
      row :average_lifespan
      row :language
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :classification
      f.input :designation
      f.input :average_height
      f.input :average_lifespan
      f.input :language
    end
    f.actions
  end
end
