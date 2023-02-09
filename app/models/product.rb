# frozen_string_literal: true

class Product < ApplicationRecord
  after_initialize :set_defaults

  has_many :discounts
  
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9_999_999.99 }

  def set_defaults
    price = 0.0
  end
end
