ActiveAdmin.register Customer do
  # Permit parameters for assignment
  permit_params :first_name, :last_name, :email, :primary_address, :primary_city, :primary_postal_code,
                :alt_address, :alt_city, :alt_postal_code, :primary_province_id, :alt_province_id

  # Add filters for searchable attributes
  filter :first_name_cont, as: :string
  filter :last_name_cont, as: :string
  filter :email_cont, as: :string
  filter :primary_address_cont, as: :string
  filter :primary_city_cont, as: :string
  filter :primary_postal_code_cont, as: :string
  filter :alt_address_cont, as: :string
  filter :alt_city_cont, as: :string
  filter :alt_postal_code_cont, as: :string
  filter :primary_province, as: :select, collection: -> { Province.all }
  filter :alt_province, as: :select, collection: -> { Province.all }
  filter :created_at
  filter :updated_at
  f.input :primary_province, as: :select, collection: Province.all.collect { |province| [province.name, province.id] }
      f.input :alt_province, as: :select, collection: Province.all.collect { |province| [province.name, province.id] }
  

  # Define index table columns
  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :email
    column :primary_address
    column :primary_city
    column :primary_postal_code
    column :alt_address
    column :alt_city
    column :alt_postal_code
    column :primary_province
    column :alt_province
    column :created_at
    column :updated_at
    actions
  end
end
