class User < ApplicationRecord
  has_secure_password

  belongs_to :province, optional: true

  has_many :orders
  has_many :cart_items

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email,
          presence: true,
          uniqueness: true,
          format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            length: { minimum: 6 },
            allow_nil: true

            def self.ransackable_attributes(auth_object = nil)
  [
    "id",
    "email",
    "name",
    "created_at",
    "updated_at"
  ]
end

def self.ransackable_associations(auth_object = nil)
  [
    "orders"
  ]
end
end
