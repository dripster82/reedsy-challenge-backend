class Discount < ApplicationRecord
  belongs_to :product

  validates :product, presence: true
  validates :qty, numericality: { greater_than_or_equal_to: 1 }
  validates :discount, numericality: { greater_than_or_equal_to: 0.001, less_than_or_equal_to: 1.000 }

end
