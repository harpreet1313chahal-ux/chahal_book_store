class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  validates :status, presence: true
  validates :total_price, presence: true
end