ActiveAdmin.register Species do
  permit_params :name, :classification, :designation, :language, :average_height, :average_lifespan, :planet_id

  index do
    selectable_column
    id_column
    column :name
    column :classification
    column :designation
    column :language
    column :average_height
    column :average_lifespan
    column :planet
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :classification
      row :designation
      row :language
      row :average_height
      row :average_lifespan
      row :planet
      row :created_at
      row :updated_at
    end

    panel "People" do
      table_for species.people do
        column :name
        column :birth_year
        column :gender
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :classification
      f.input :designation
      f.input :language
      f.input :average_height
      f.input :average_lifespan
      f.input :planet
    end
    f.actions
  end

  controller do
    def create
      @species = Species.new(permitted_params[:species])
      if @species.save
        redirect_to admin_species_path(@species), notice: "Species was successfully created."
      else
        render :new
      end
    end

    def update
      @species = Species.find(params[:id])
      if @species.update(permitted_params[:species])
        redirect_to admin_species_path(@species), notice: "Species was successfully updated."
      else
        render :edit
      end
    end
  end
end
