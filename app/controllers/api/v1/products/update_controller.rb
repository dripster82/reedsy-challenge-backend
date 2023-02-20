# frozen_string_literal: true

module Api
  module V1
    module Products
      class UpdateController < ApplicationController
        def index
          update_service = ::Products::UpdateService.call(code: params[:code], data: params.fetch(:data, nil))
          render json: update_service[:json], status: update_service[:status]
        end
      end
    end
  end
end
