class User < ApplicationRecord
  has_many :orders
  has_many :cart_items

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
end