# frozen_string_literal: true

require 'rails_helper'
require 'jsonapi'

module Api
  module V1
    module Products
      RSpec.describe UpdateController, type: :request do
        describe '#index' do
          let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
          let(:new_price) { 17.99 }
          let(:params) do
            {
              data: {
                attributes: {
                  price: new_price
                }
              }
            }
          end

          it 'calls the correct service' do
            expect(::Products::UpdateService)
              .to receive(:call)
              .with(
                {
                  code: mug.code,
                  data: ActionController::Parameters.new(
                    attributes: ActionController::Parameters.new(price: new_price.to_s)
                  )
                }
              )

            allow(::Products::UpdateService).to receive(:call).and_call_original

            patch "/api/v1/products/#{mug.code}", params: params
          end

          it 'reponds with the serivces output' do
            allow(::Products::UpdateService)
              .to receive(:call)
              .with(
                {
                  code: mug.code,
                  data: ActionController::Parameters.new(
                    attributes: ActionController::Parameters.new(price: new_price.to_s)
                  )
                }
              )
              .and_return({ json: 'all good', status: :ok })

            patch "/api/v1/products/#{mug.code}", params: params

            expect(response).to have_http_status(:ok)
            expect(response.body).to eq 'all good'
          end
        end
      end
    end
  end
end
