# frozen_string_literal: true

require 'rails_helper'
require 'jsonapi'

module Api
  module V1
    module Products
      RSpec.describe QuoteController, type: :request do
        describe '#index' do
          let(:params) do
            {
              data: [
                { id: 'MUG', type: 'QuoteLine', attributes: { code: 'MUG', qty: 3 } },
                { id: 'HOODIE', type: 'QuoteLine', attributes: { code: 'HOODIE', qty: 1 } }
              ]
            }
          end

          it 'calls the correct service' do
            expect(::Products::QuoteService)
              .to receive(:call)
              .with(
                {
                  quote_lines: params[:data]
                }
              )

            allow(::Products::QuoteService).to receive(:call).and_return({ json: 'all good', status: :ok })

            post '/api/v1/products/quote', params: params.to_json
          end

          it 'reponds with the serivces output' do
            allow(::Products::QuoteService)
              .to receive(:call)
              .and_return({ json: 'all good', status: :ok })

            post '/api/v1/products/quote', params: params.to_json

            expect(response).to have_http_status(:ok)
            expect(response.body).to eq 'all good'
          end
        end
      end
    end
  end
end
