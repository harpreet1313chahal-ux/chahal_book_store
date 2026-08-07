class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

has_many :order_items
has_many :orders, through: :order_items

has_many :cart_items

validates :title, presence: true

validates :author, presence: true

validates :isbn,
          presence: true,
          uniqueness: true

validates :description, presence: true

validates :price,
          presence: true,
          numericality: { greater_than: 0 }

validates :stock_quantity,
          presence: true,
          numericality: { greater_than_or_equal_to: 0 }

          def self.ransackable_attributes(auth_object = nil)
  [
    "id",
    "name",
    "description",
    "price",
    "stock_quantity",
    "category_id",
    "created_at",
    "updated_at"
  ]
end

def self.ransackable_associations(auth_object = nil)
  [
    "cart_items",
    "category",
    "order_items",
    "orders",
    "image_attachment",
    "image_blob"
  ]
end
end
