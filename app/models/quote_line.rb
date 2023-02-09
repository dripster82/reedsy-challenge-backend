# frozen_string_literal: true

class QuoteLine
  include ActiveModel::Model

  attr_accessor :code, :qty, :product_price, :line_price

  validates :code, presence: true
  validates :qty, numericality: { greater_than_or_equal_to: 0 }
  validates :product_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :line_price, numericality: { greater_than_or_equal_to: 0.0 }

  def initialize(code:, qty:)
    @qty = qty
    product = Product.find_by(code: code)

    return unless product

    @code = product.code
    @product_price = product.price
    @line_price = product.price
  end

  def total_price
    return 0.0 unless valid?

    qty * line_price
  end
end
