# frozen_string_literal: true

class QuoteLine
  include ActiveModel::Model

  attr_accessor :code, :qty, :product, :product_price, :line_price

  validates :code, presence: true
  validates :qty, numericality: { greater_than_or_equal_to: 0 }
  validates :product_price, numericality: { greater_than_or_equal_to: 0.0 }
  validates :line_price, numericality: { greater_than_or_equal_to: 0.0 }

  def initialize(code:, qty:)
    @qty = qty
    @product = Product.includes(:discounts).find_by(code: code)

    return unless product

    @code = product.code
    @product_price = product.price
    @line_price = product.price * discount_percentage
  end

  def total_price
    return 0.0 unless valid?

    qty * line_price
  end

  def discount_percentage
    return @discount_percentage if @discount_percentage

    @discount_percentage = 1
    unless product.discounts.empty?
      @discount_percentage -= product.discounts.find_all { |discount| discount.qty <= qty }.max_by(&:qty).discount
    end

    @discount_percentage
  end

  private

  attr_writer :discount_percentage
end
