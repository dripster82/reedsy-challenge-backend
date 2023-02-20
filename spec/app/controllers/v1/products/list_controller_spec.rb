# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    module Products
      RSpec.describe ListController, type: :request do
        describe '#index' do
          let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
          let(:tshirt) { create(:product, code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }
          let(:hoodie) { create(:product, code: 'HOODIE', name: 'Reedsy Hoodie', price: 20.00) }
          let(:expected_json) do
            {
              'data'	=> []
            }
          end

          context 'when data exists' do
            before do
              [mug, tshirt, hoodie].each do |product|
                expected_json['data'] << {
                  'id' => product.code,
                  'type' => 'Product',
                  'attributes' => {
                    'code' => product.code,
                    'name' => product.name,
                    'price' => product.price
                  }
                }
              end
            end

            it 'returns the correct data' do
              get '/api/v1/products'

              expect(response).to have_http_status(:success)
              expect(JSON.parse(response.body)).to eq expected_json
            end
          end

          context 'when no data exists' do
            before do
              expected_json
            end

            it 'returns the correct data' do
              get '/api/v1/products'

              expect(response).to have_http_status(:success)
              expect(JSON.parse(response.body)).to eq expected_json
            end
          end
        end
      end
    end
  end
end
