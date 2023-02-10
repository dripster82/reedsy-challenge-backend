# frozen_string_literal: true

module Api
  module V1
    module Products
      class UpdateController < ApplicationController
        def index
          attributes = params.fetch(:data, nil)
          attributes = attributes[:attributes].permit(:code, :name, :price).to_hash.symbolize_keys if attributes.is_a?(Hash) && attributes[:attributes]
          update_service = ::Products::UpdateService.call(code: params[:code], attributes: attributes)

          render json: update_service[:json], status: update_service[:status]
        end
      end
    end
  end
end
