class AddOnSaleStatusToProducts < ActiveRecord::Migration[7.1]
  def change
    change_column :products, :on_sale_status, :boolean
  end
end
