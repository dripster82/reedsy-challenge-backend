# frozen_string_literal: true

module Api
  module V1
    class QuoteLineSerializer
      include JSONAPI::Serializer

      attributes :code, :qty, :product_price, :line_price, :total_price

      attribute :discount_percentage do |quote_line|
        ((1 - quote_line.discount_percentage) * 100).round(1)
      end

      set_id :code

      set_key_transform :camel
    end
  end
end
