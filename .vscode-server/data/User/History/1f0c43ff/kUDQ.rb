class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:brands)
    create_table :brands do |t|
      t.string :name

      t.timestamps
    end
  end
end
end
