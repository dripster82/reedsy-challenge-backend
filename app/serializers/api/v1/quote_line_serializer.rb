# frozen_string_literal: true

module Api
  module V1
    class QuoteLineSerializer
      include JSONAPI::Serializer

      attributes :code

      attribute :qty do |quote_line|
        quote_line.qty.to_i
      end

      attribute :product_price do |quote_line|
        quote_line.product_price.to_f
      end

      attribute :line_price do |quote_line|
        quote_line.line_price.to_f
      end

      attribute :total_price do |quote_line|
        quote_line.total_price.to_f
      end

      attribute :discount_percentage do |quote_line|
        ((1 - quote_line.discount_percentage) * 100).round(1).to_f
      end

      set_id :code

      set_key_transform :camel
    end
  end
end
