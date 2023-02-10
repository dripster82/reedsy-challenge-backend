# frozen_string_literal: true

module Products
  class QuoteService < ApplicationService
    def initialize(quote_lines:)
      @raw_quote_lines = quote_lines
    end

    def call
      return no_data_response unless quote_lines || !quote_lines.is_a?(Array)

      build_quote

      return quote_response if quote.valid?

      error_response
    end

    private

    attr_reader :raw_quote_lines, :quote, :quote_lines, :json, :status

    def build_quote
      compact_lines
      @quote = Quote.new(quote_lines: quote_lines.values)
    end

    def compact_lines
      @quote_lines = {}
      raw_quote_lines.each do |quote_line_data|
        next if quote_line_data[:type] != 'QuoteLine'

        code = quote_line_data[:id]
        qty = quote_line_data[:attributes][:qty]
        quote_line = QuoteLine.new(code: code, qty: qty)

        next unless quote_line.valid?

        if quote_lines.key?(code)
          quote_lines[code].qty += qty
        else
          quote_lines[code] = quote_line
        end
      end
    end

    def quote_response
      {
        json: Api::V1::QuoteSerializer.new(quote, { include: [:quote_lines] }).to_json,
        status: :ok
      }
    end

    def error_response
      {
        json: quote.errors.to_json,
        status: :bad_request
      }
    end

    def no_data_response
      {
        json: { error: ['Invalid request data'] }.to_json,
        status: :bad_request
      }
    end
  end
end
