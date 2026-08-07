ActiveAdmin.register Product do
  permit_params :title,
                :author,
                :isbn,
                :description,
                :price,
                :stock_quantity,
                :category_id

  config.filters = false
end
