class CreateOrderSummaries < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:create_order_summar)
    create_table :order_summaries do |t|
      t.references :order, null: false, foreign_key: true
      t.string :summary

      t.timestamps
    end
  end
end