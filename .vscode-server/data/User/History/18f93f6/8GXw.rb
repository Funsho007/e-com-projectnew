ActiveAdmin.register Product do
  permit_params :name, :brand_id, :type_id, :category_id, :price, :description, :on_sale_status, :image, tag_ids: []

  # Remove image_attachment from filters
  filter :name
  filter :brand
  filter :type
  filter :category
  filter :price
  filter :on_sale_status
  filter :tags
  filter :created_at
  filter :updated_at

  # Form configuration
  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :brand
      f.input :type
      f.input :category
      f.input :price
      f.input :description
      f.input :on_sale_status
      f.input :tags, as: :check_boxes, collection: Tag.all
      if f.object.image.attached?
        f.input :image, as: :file, hint: image_tag(f.object.image.variant(resize_to_fill: [100, 100]).processed)
      else
        f.input :image, as: :file, hint: 'Upload an image'
      end
    end
    f.actions
  end

  # Index configuration
  index do
    selectable_column
    id_column
    column :image do |product|
      if product.image.attached?
        image_tag product.image.variant(resize_to_limit: [50, 50]).processed
      else
        "No image attached"
      end
    end
    column :name
    column :brand
    column :type
    column :category
    column :price
    column :on_sale_status
    column :tags do |product|
      product.tags.map(&:name).join(', ')
    end
    column :created_at
    column :updated_at
    actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :id
      row :name
      row :brand
      row :type
      row :category
      row :price
      row :description
      row :on_sale_status
      row :image do |product|
        if product.image.attached?
          image_tag product.image.variant(resize_to_limit: [200, 200]).processed
        else
          "No image attached"
        end
      end
      row :tags do |product|
        product.tags.map(&:name).join(', ')
      end
    end
    active_admin_comments
  end

  # Adding action items
  action_item :edit, only: :show do
    link_to 'Edit Product', edit_admin_product_path(resource)
  end

  action_item :new, only: :index do
    link_to 'Create New Product', new_admin_product_path
  end

  action_item :update, only: :show do
    link_to 'Update Product', edit_admin_product_path(resource)
  end

  # Panel for actions in show page
  sidebar "Actions", only: :show do
    ul do
      li link_to 'Edit Product', edit_admin_product_path(resource)
      li link_to 'Create New Product', new_admin_product_path
      li link_to 'Update Product', edit_admin_product_path(resource)
    end
  end

  # Panel for actions in index page
  sidebar "Actions", only: :index do
    ul do
      li link_to 'Create New Product', new_admin_product_path
    end
  end

end
