# frozen_string_literal: true

module Api
  module V1
    module Products
      class UpdateController < ApplicationController
        def index
          update_data = JSON.parse(request.raw_post, symbolize_names: true)

          begin
            attributes = update_data[:data][:attributes] || nil
          rescue StandardError
            attributes = nil
          end

          update_service = ::Products::UpdateService.call(code: params[:code], attributes: attributes)

          render json: update_service[:json], status: update_service[:status]
        end
      end
    end
  end
end
