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

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total_price
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :status, as: :select, collection: Order::STATUSES
      f.input :total_price
      f.input :shipping_address
      f.input :gst_rate
      f.input :pst_rate
      f.input :hst_rate
      f.input :tax_amount
    end

    f.actions
  end
end
