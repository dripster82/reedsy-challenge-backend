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

          context "when invalid data is passed" do
            it 'reponds with the correct serivces output' do
              allow(::Products::QuoteService)
                .to receive(:call)
                .and_return({ json: 'all good', status: :ok })

              post '/api/v1/products/quote', params: params.to_json

              expect(response).to have_http_status(:ok)
              expect(response.body).to eq 'all good'
            end
          end

          context "when invalid data is passed" do
            context "such as no data" do
              it 'reponds with the correct status' do
                allow(::Products::QuoteService)
                  .to receive(:call)
                  .and_return({ json: 'issues', status: :bad_request })

                post '/api/v1/products/quote'

                expect(response).to have_http_status(:bad_request)
                expect(response.body).to eq 'issues'
              end
            end

            context "such as none json request" do
              it 'reponds with the serivces output' do
                allow(::Products::QuoteService)
                  .to receive(:call)
                  .and_return({ json: 'issues', status: :bad_request })

                post '/api/v1/products/quote', params: "hello?"

                expect(response).to have_http_status(:bad_request)
                expect(response.body).to eq 'issues'
              end
            end
          end
        end
      end
    end
  end
end
