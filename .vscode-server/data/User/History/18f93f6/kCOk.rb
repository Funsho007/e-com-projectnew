# app/admin/products.rb

ActiveAdmin.register Product do
  permit_params :name, :brand_id, :type_id, :category_id, :price, :description, :on_sale_status, tag_ids: []

  # Controller customizations
  controller do
    def scoped_collection
      super.includes(:brand, :type, :category, :tags) # Removed image_attachment
    end
  end

  # Form configuration
  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image.variant(resize_to_fill: [100, 100])) : content_tag(:span, "Upload image")
    end
    f.input :tags, as: :check_boxes, collection: Tag.all.map { |tag| [tag.name, tag.id] }
    f.actions
  end

  # Index configuration
  index do
    selectable_column
    id_column
    column :image do |product|
      if product.image.attached?
        image_tag product.image.variant(resize_to_limit: [50, 50])
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
      tags = product.tags.map(&:name).join(', ')
      tags.present? ? tags : 'N/A'
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
          image_tag product.image.variant(resize_to_limit: [200, 200])
        else
          "No image attached"
        end
      end
      row :tags do |product|
        product.tags.each do |tag|
          span tag.name
        end
      end
    end
    active_admin_comments
  end
end
