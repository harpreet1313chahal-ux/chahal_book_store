class AddTaxSnapshotToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :gst_rate, :decimal
    add_column :orders, :pst_rate, :decimal
    add_column :orders, :hst_rate, :decimal
    add_column :orders, :tax_amount, :decimal
  end
end
