class Order < ApplicationRecord
  belongs_to :user
  
  validates :user, presence: true

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  STATUSES = [ "New", "Paid", "Shipped" ].freeze

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :total_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
end
