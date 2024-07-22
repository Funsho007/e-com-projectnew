class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :tax_type
      t.decimal :gst
      t.decimal :pst
      t.decimal :hst
      t.decimal :qst

      t.timestamps
    end
  end
end
