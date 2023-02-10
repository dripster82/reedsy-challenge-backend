# frozen_string_literal: true

module Api
  module V1
    class QuoteSerializer
      include JSONAPI::Serializer

      attributes :total_price
      has_many :quote_lines, serializer: Api::V1::QuoteLineSerializer
      # attributes :quote_lines do |quote|
      #   Api::V1::QuoteLineSerializer.new(quote.quote_lines)
      # end

      set_id { 'temp_quote_id' }

      set_key_transform :camel
    end
  end
end
