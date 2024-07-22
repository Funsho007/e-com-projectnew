class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:customers)
    create_table :customers do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
end