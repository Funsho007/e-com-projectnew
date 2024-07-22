class AddProvincesToCustomers < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:province)
    add_column :customers, :primary_province_id, :integer
    add_column :customers, :alt_province_id, :integer
  end
end
end
