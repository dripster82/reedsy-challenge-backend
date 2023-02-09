# frozen_string_literal: true

# module Products
module Products
  class UpdateService < ApplicationService
    attr_reader :code, :attributes, :json, :status, :product

    def initialize(code:, attributes:)
      @code = code
      @attributes = attributes
    end

    def call
      return no_data_response unless attributes
      return no_product_response unless product

      attributes.each do |attribute, value|
        product[attribute] = value
      end

      if product.valid?
        product.save!
        {
          json: Api::V1::ProductSerializer.new(product).to_json,
          status: :ok
        }
      else
        {
          json: product.errors.to_json,
          status: :bad_request
        }
      end
    end

    private

    def no_data_response
      {
        json: { error: ['Invalid request data'] }.to_json,
        status: :bad_request
      }
    end

    def no_product_response
      {
        json: { code: ['Product not found'] }.to_json,
        status: :bad_request
      }
    end

    def product
      @product ||= Product.find_by(code: code)
    end
  end
end
# end
