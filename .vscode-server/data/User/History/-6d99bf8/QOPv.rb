ActiveAdmin.register Customer do
  permit_params :first_name, :last_name, :email, :primary_address, :primary_city, :primary_postal_code,
                :alt_address, :alt_city, :alt_postal_code, :primary_province_id, :alt_province_id

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
