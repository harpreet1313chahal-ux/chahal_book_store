class User < ApplicationRecord
  has_secure_password

  belongs_to :province, optional: true

  has_many :orders
  has_many :cart_items

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email,
            presence: true,
            uniqueness: true

  validates :password,
            length: { minimum: 6 },
            allow_nil: true
end
