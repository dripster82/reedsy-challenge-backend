# frozen_string_literal: true

module Api
  module V1
    class QuoteSerializer
      include JSONAPI::Serializer

      attribute :total_price do |quote|
        quote.total_price.to_f
      end

      has_many :quote_lines, serializer: Api::V1::QuoteLineSerializer

      set_id { 'temp_quote_id' }

      set_key_transform :camel
    end
  end
end
