class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:order_items)
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
end