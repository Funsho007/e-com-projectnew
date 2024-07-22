class FixProvinceAttributes < ActiveRecord::Migration[6.1]
  def change
    change_table :provinces do |t|
      t.rename :GST, :gst
      t.rename :PST, :pst
      t.rename :HST, :hst
      t.rename :QST, :qst
    end
  end
end
