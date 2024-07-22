class FixProvinceAttributes < ActiveRecord::Migration[6.1]
  def change
    change_table :provinces do |t|
      # Add the columns if they don't exist
      t.decimal :gst, precision: 5, scale: 2, default: 0.0 unless column_exists?(:provinces, :gst)
      t.decimal :pst, precision: 5, scale: 2, default: 0.0 unless column_exists?(:provinces, :pst)
      t.decimal :hst, precision: 5, scale: 2, default: 0.0 unless column_exists?(:provinces, :hst)

      # Remove old columns if they exist
      t.remove :GST if column_exists?(:provinces, :GST)
      t.remove :PST if column_exists?(:provinces, :PST)
      t.remove :HST if column_exists?(:provinces, :HST)
    end
  end
end
