class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.references :brand, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.text :description
      t.boolean :on_sale_status

      t.timestamps
    end
  end
end
