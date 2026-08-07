ActiveAdmin.register Order do
  permit_params :user_id,
                :order_date,
                :total_price,
                :status,
                :shipping_address,
                :gst_rate,
                :pst_rate,
                :hst_rate,
                :tax_amount
end