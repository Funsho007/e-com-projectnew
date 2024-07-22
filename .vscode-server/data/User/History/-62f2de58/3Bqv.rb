ActiveAdmin.register Order do

  actions :index, :edit, :update, :destroy
  permit_params :total, :delivery_charges, :status, :user_id, :payment_method, :address

  filter :products_id

end
