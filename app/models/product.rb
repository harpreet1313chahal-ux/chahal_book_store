class Product < ApplicationRecord
  belongs_to :category

has_many :order_items
has_many :orders, through: :order_items

has_many :cart_items

validates :title, presence: true
validates :author, presence: true
validates :isbn, presence: true
validates :description, presence: true
validates :price, presence: true
validates :stock_quantity, presence: true
end
