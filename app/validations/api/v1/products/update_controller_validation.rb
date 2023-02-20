# frozen_string_literal: true

module Api
  module V1
    module Products
      class UpdateControllerValidation < ::Dry::Validation::Contract
        params do
          required(:data).schema do
            required(:attributes).schema do
              optional(:code).filled(:string)
              optional(:name).filled(:string)
              optional(:price).filled(:float, gteq?: 0.0, lteq?: 9999999.99)
            end
          end
        end
      end
    end
  end
end
