ActiveAdmin.register Province do
  permit_params :name, :gst_rate, :pst_rate, :hst_rate

  index do
    selectable_column
    id_column
    column :name
    column :gst_rate
    column :pst_rate
    column :hst_rate
    actions
  end

  form do |f|
  f.inputs do
    f.input :name
    f.input :gst
    f.input :pst
    f.input :hst
  end

  f.actions
end
end
