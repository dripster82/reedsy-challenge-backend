# frozen_string_literal: true

module Api
  module V1
    module Products
      class ListController < ApplicationController
        def index
          products = Product.all

          if products
            render json: Api::V1::ProductSerializer.new(products).to_json, status: :ok
          else
            render json: products.errors, status: :bad_request
          end
        end
      end
    end
  end
end
