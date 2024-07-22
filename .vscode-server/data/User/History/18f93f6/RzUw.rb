ActiveAdmin.register Product do
  permit_params :name, :brand_id, :type_id, :category_id, :price, :description, :on_sale_status, :image, tag_ids: []

  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      f.input :brand
      f.input :type
      f.input :category
      f.input :price
      f.input :description
      f.input :on_sale_status
      f.input :image, as: :file
      f.input :tags, as: :check_boxes
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :brand
    column :type
    column :category
    column :price
    column :on_sale_status
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :brand
      row :type
      row :category
      row :price
      row :description
      row :on_sale_status
      row :image do |product|
        image_tag url_for(product.image) if product.image.attached?
      end
      row :tags do |product|
        product.tags.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end
end
