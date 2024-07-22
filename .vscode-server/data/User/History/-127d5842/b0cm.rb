class ChangeColumnDefaultForTableName < ActiveRecord::Migration[7.1]
  def change
   
      change_column_default :products, :on_sale_status, 1
  end
end
