ActiveAdmin.register Person do
  permit_params :name, :species_id, :planet_id, :birth_year, :gender

  index do
    selectable_column
    id_column
    column :name
    column :species
    column :planet
    column :birth_year
    column :gender
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :species
      row :planet
      row :birth_year
      row :gender
      row :created_at
      row :updated_at
    end

    panel "Films" do
      table_for person.films do
        column :title
        column :director
        column :release_date
      end
    end

    panel "Starships" do
      table_for person.starships do
        column :name
        column :model
        column :manufacturer
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :species
      f.input :planet
      f.input :birth_year
      f.input :gender
    end
    f.actions
  end
end
