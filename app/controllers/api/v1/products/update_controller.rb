# frozen_string_literal: true

module Api
  module V1
    module Products
      class UpdateController < ApplicationController
        def index
          attributes = params.fetch(:data, nil)
          if attributes.is_a?(ActionController::Parameters) && attributes[:attributes]
            attributes = attributes[:attributes]
            .permit(:code, :name, :price)
            .to_hash
            .deep_symbolize_keys
          end
          update_service = ::Products::UpdateService.call(code: params[:code], attributes: attributes)

          render json: update_service[:json], status: update_service[:status]
        end
      end
    end
  end
end
