class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:orders)
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
end
