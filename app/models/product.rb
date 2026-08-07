class Product < ApplicationRecord
  belongs_to :category

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
end
