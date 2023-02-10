# frozen_string_literal: true

class Quote
  include ActiveModel::Model

  validates :quote_line_arr, length: { minimum: 1 }

  def initialize(quote_lines: [])
    clear_quote_lines
    add_quote_lines(quote_lines)
  end

  # validates :quote_lines, count_

  def total_price
    total_price = 0.0

    return total_price unless quote_lines.count.positive?

    quote_lines.each do |quote_line|
      total_price += quote_line.total_price
    end

    total_price.round(2)
  end

  def add_quote_lines(quote_lines)
    return add_quote_line(quote_lines) if quote_lines.is_a?(QuoteLine)
    return unless quote_lines.is_a?(Array)

    quote_lines.each do |quote_line|
      add_quote_line(quote_line)
    end
  end

  def add_quote_line(quote_line)
    @quote_line_arr << quote_line if quote_line.is_a?(QuoteLine) && quote_line.valid?
  end

  def quote_lines
    @quote_line_arr.clone
  end

  def clear_quote_lines
    @quote_line_arr = []
  end

  def delete_quote_line(quote_line)
    @quote_line_arr.delete(quote_line)
  end

  def quote_line_ids
    quote_line_arr.map(&:code)
  end

  private

  attr_reader :quote_line_arr
end
