ActiveAdmin.register Planet do
  permit_params :name, :climate, :terrain, :population

  index do
    selectable_column
    id_column
    column :name
    column :climate
    column :terrain
    column :population
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :climate
      row :terrain
      row :population
      row :created_at
      row :updated_at
    end

    panel "Species" do
      table_for planet.species do
        column :name
        column :classification
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :climate
      f.input :terrain
      f.input :population
    end
    f.actions
  end
end
