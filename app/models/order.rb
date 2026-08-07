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

def self.ransackable_attributes(auth_object = nil)
  [
    "id",
    "user_id",
    "order_date",
    "total_price",
    "status",
    "shipping_address",
    "gst_rate",
    "pst_rate",
    "hst_rate",
    "tax_amount",
    "created_at",
    "updated_at"
  ]
end

def self.ransackable_associations(auth_object = nil)
  [
    "order_items",
    "products",
    "user"
  ]
end
end
