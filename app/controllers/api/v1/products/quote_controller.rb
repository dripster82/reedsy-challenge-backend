# frozen_string_literal: true

module Api
  module V1
    module Products
      class QuoteController < ApplicationController
        def index
          update_data = JSON.parse(request.raw_post, symbolize_names: true)

          begin
            quote_lines = update_data[:data] || nil
          rescue StandardError
            quote_lines = nil
          end

          quote_service = ::Products::QuoteService.call(quote_lines: quote_lines)

          render json: quote_service[:json], status: quote_service[:status]
        end
      end
    end
  end
end
