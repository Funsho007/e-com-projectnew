ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :price, :brand_id, :type_id, :category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :brand_id, :type_id, :category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  # app/admin/products.rb
ActiveAdmin.register Product do
  permit_params :name, :description, :price, :brand_id, :type_id, :category_id, :image, :tag_ids => []

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :brand
      f.input :type
      f.input :category
      f.input :tags, as: :check_boxes
      f.input :image, as: :file
    end
    f.actions
  end
end

end
