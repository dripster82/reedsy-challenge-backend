# frozen_string_literal: true

module Api
  module V1
    class QuoteLineSerializer
      include JSONAPI::Serializer

      attributes :code, :qty, :product_price, :line_price, :total_price

      set_id :code

      set_key_transform :camel
    end
  end
end
