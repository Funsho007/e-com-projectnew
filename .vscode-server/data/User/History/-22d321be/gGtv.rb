ActiveAdmin.register Film do
  permit_params :title, :episode_id, :opening_crawl, :director, :producer, :release_date

  index do
    selectable_column
    id_column
    column :title
    column :episode_id
    column :director
    column :producer
    column :release_date
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :episode_id
      row :opening_crawl
      row :director
      row :producer
      row :release_date
      row :created_at
      row :updated_at
    end

    panel "Characters" do
      table_for film.people do
        column :name
        column :birth_year
        column :gender
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :episode_id
      f.input :opening_crawl
      f.input :director
      f.input :producer
      f.input :release_date
    end
    f.actions
  end

    remove_filter :characters, :people
    
  end
