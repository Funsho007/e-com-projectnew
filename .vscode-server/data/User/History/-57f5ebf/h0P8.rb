class CreateTypes < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:types)
    create_table :types do |t|
      t.string :name

      t.timestamps
    end
  end
end
end
