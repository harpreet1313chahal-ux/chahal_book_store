class CreateProvinces < ActiveRecord::Migration[8.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :gst, precision: 4, scale: 2
      t.decimal :pst, precision: 4, scale: 2
      t.decimal :hst, precision: 4, scale: 2

      t.timestamps
    end
  end
end
