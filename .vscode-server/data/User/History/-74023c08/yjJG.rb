ActiveAdmin.register Starship do
  permit_params :name, :model, :manufacturer, :cost_in_credits, :length, :max_atmosphering_speed, :crew, :passengers, :cargo_capacity, :consumables, :hyperdrive_rating, :MGLT, :starship_class

  index do
    selectable_column
    id_column
    column :name
    column :model
    column :manufacturer
    column :cost_in_credits
    column :length
    column :max_atmosphering_speed
    column :crew
    column :passengers
    column :cargo_capacity
    column :consumables
    column :hyperdrive_rating
    column :MGLT
    column :starship_class
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :model
      row :manufacturer
      row :cost_in_credits
      row :length
      row :max_atmosphering_speed
      row :crew
      row :passengers
      row :cargo_capacity
      row :consumables
      row :hyperdrive_rating
      row :MGLT
      row :starship_class
      row :created_at
      row :updated_at
    end

    panel "Pilots" do
      table_for starship.people do
        column :name
        column :birth_year
        column :gender
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :model
      f.input :manufacturer
      f.input :cost_in_credits
      f.input :length
      f.input :max_atmosphering_speed
      f.input :crew
      f.input :passengers
      f.input :cargo_capacity
      f.input :consumables
      f.input :hyperdrive_rating
      f.input :MGLT
      f.input :starship_class
    end
    f.actions
  end
end
