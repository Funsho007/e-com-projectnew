ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :stock
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :stock]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
 
    permit_params :name, :description, :price, :stock, :image

    index do
      selectable_column
      id_column
      column :name
      column :description
      column :price
      column :stock
      column :image do |product|
        if product.image.attached?
          image_tag url_for(product.image.variant(resize_to_limit: [50, 50]))
        end
      end
      actions
    end

    form do |f|
      f.inputs do
        f.input :name
        f.input :description
        f.input :price
        f.input :stock
        f.input :image, as: :file
      end
      f.actions
    end

    show do
      attributes_table do
        row :name
        row :description
        row :price
        row :stock
        row :image do |product|
          if product.image.attached?
            image_tag url_for(product.image.variant(resize_to_limit: [300, 300]))
          end
        end
      end
    end
  end
