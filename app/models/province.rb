class Province < ApplicationRecord
  has_many :users

  validates :name, presence: true

  validates :gst,
            numericality: { greater_than_or_equal_to: 0 }

  validates :pst,
            numericality: { greater_than_or_equal_to: 0 }

  validates :hst,
            numericality: { greater_than_or_equal_to: 0 }


  def self.ransackable_attributes(auth_object = nil)
    [
      "id",
      "name",
      "gst",
      "pst",
      "hst",
      "created_at",
      "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "users"
    ]
  end
end
