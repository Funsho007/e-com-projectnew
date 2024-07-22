class CreateJoinTableProductsTags < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:products_tags)
      create_join_table :products, :tags do |t|
        t.index [:product_id, :tag_id]
        t.index [:tag_id, :product_id]
    end
  end
end
