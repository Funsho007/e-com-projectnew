ActiveAdmin.register OtherUser do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :name, :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    actions
  end

  filter :name
  filter :email

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
    end
    active_admin_comments
  end

  controller do
    def ransackable_attributes(auth_object = nil)
      %w[created_at email id name updated_at]
    end
  end
end
