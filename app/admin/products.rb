ActiveAdmin.register Product do
  permit_params :title,
                :author,
                :isbn,
                :description,
                :price,
                :stock_quantity,
                :image_url,
                :category_id
end