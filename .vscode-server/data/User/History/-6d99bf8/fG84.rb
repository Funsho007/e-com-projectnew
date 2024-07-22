ActiveAdmin.register Customer do
  permit_params :first_name, :last_name, :email, :primary_address, :primary_city, :primary_postal_code,
                :alt_address, :alt_city, :alt_postal_code, :primary_province_id, :alt_province_id

  filter :first_name
  filter :last_name
  filter :email
  filter :primary_address
  filter :primary_city
  filter :primary_postal_code
  filter :alt_address
  filter :alt_city
  filter :alt_postal_code
  filter :primary_province, as: :select, collection: -> { Province.all.collect { |province| [province.name, province.id] } }
  filter :alt_province, as: :select, collection: -> { Province.all.collect { |province| [province.name, province.id] } }
  filter :created_at
  filter :updated_at

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

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :primary_address
      f.input :primary_city
      f.input :primary_postal_code
      f.input :alt_address
      f.input :alt_city
      f.input :alt_postal_code
      f.input :primary_province, as: :select, collection: Province.all.collect { |province| [province.name, province.id] }
      f.input :alt_province, as: :select, collection: Province.all.collect { |province| [province.name, province.id] }
    end
    f.actions
  end
end
