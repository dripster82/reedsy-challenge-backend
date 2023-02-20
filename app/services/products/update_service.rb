# frozen_string_literal: true

# module Products
module Products
  class UpdateService < ApplicationService
    attr_reader :code, :data, :json, :status

    def initialize(code:, data:)
      @code = code
      @data = data || {}
    end

    def call
      return invalid_data_response unless valid?
      return no_product_response unless product

      validator[:data][:attributes].each do |attribute, value|
        product[attribute] = value
      end

      if product.valid?
        product.save!
        {
          json: Api::V1::ProductSerializer.new(product).to_hash,
          status: :ok
        }
      else
        {
          json: product.errors,
          status: :bad_request
        }
      end
    end

    def product
      @product ||= Product.find_by(code: code)
    end

    private

    attr_writer :product

    def valid?
      validator.success?
    end

    def validator
      @_validator ||= Api::V1::Products::UpdateControllerValidation.new.call({ data: @data })
    end

    def invalid_data_response
      {
        json: validator.errors.to_hash,
        status: :bad_request
      }
    end

    def no_product_response
      {
        json: { code: ['Product not found'] },
        status: :not_found
      }
    end
  end
end
# end
