class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:static_pages)
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
