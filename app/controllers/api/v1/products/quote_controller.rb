# frozen_string_literal: true

module Api
  module V1
    module Products
      class QuoteController < ApplicationController
        def index
          quote_lines = params.fetch(:data, nil)
          if quote_lines.is_a?(Array)
            quote_lines = quote_lines.map { |obj|
              obj.permit(:id, :type, attributes: %i[code qty]).to_hash.deep_symbolize_keys
            }
          end
          quote_service = ::Products::QuoteService.call(quote_lines: quote_lines)

          render json: quote_service[:json], status: quote_service[:status]
        end
      end
    end
  end
end
