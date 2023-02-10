# frozen_string_literal: true

require 'rails_helper'
require 'jsonapi'
module Products
  RSpec.describe UpdateService do
    subject { described_class.new(code: code, attributes: attributes) }
    let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
    let(:code) { mug.code }
    let(:tshirt) { create(:product, code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }
    let(:new_price) { 17.99 }

    context 'when valid data is sent' do
      let(:new_code) { 'MUG2' }
      let(:new_name) { 'Reedsy Rebranded Mug' }
      let(:new_price) { 17.99 }
      let(:attributes) do
        {
          code: new_code,
          name: new_name,
          price: new_price
        }
      end

      it 'updates the product with the new values' do
        results = subject.call

        expect(results[:status]).to eq :ok

        old_product = Product.find_by(code: mug.code)
        expect(old_product).to be_nil

        product = Product.find_by(code: new_code)
        expect(product.price).to eq new_price
        expect(product.name).to eq new_name
      end

      it 'returns the product with the new values' do
        results = subject.call

        expect(results[:status]).to eq :ok

        json_data = JSON.parse(results[:json], symbolize_names: true)[:data]

        expect(json_data[:attributes][:code]).to eq new_code
        expect(json_data[:attributes][:name]).to eq new_name
        expect(json_data[:attributes][:price]).to eq new_price.to_s
      end

      context 'with just the new_price sent' do
        before do
          attributes.delete(:code)
          attributes.delete(:name)
        end

        it 'updates the product with the new price' do
          results = subject.call

          product = Product.find_by(code: mug.code)

          expect(results[:status]).to eq :ok
          expect(product.price).to eq new_price
          expect(product.name).to eq mug.name
        end

        context 'with the price as a string' do
          before do
            attributes[:price] = new_price.to_s
          end

          it 'updates the product with the new value' do
            results = subject.call

            product = Product.find_by(code: mug.code)

            expect(results[:status]).to eq :ok
            expect(product.price).to eq new_price
            expect(product.name).to eq mug.name
          end
        end
      end
    end

    context 'when invalid data is sent' do
      context 'with the price is invalid' do
        [
          { price: -10.01, reason: 'must be greater than or equal to 0' },
          { price: 10_000_000.00, reason: 'must be less than or equal to 9999999.99' },
          { price: 'abc', reason: 'is not a number' },
          { price: nil, reason: 'is not a number' }
        ].each do |test_data|
          context "of '#{test_data[:price]}'" do
            let(:attributes) do
              {
                price: test_data[:price]
              }
            end

            it 'returns 400 with correct error message' do
              results = subject.call
              expect(results[:status]).to eq :bad_request

              json_data = JSON.parse(results[:json], symbolize_names: true)
              expect(json_data[:price][0]).to eq test_data[:reason]

              product = Product.find_by(code: mug.code)

              expect(product.price).to eq mug.price
              expect(product.name).to eq mug.name
            end
          end
        end
      end

      context 'with the code already existing' do
        let(:attributes) do
          {
            code: tshirt.code,
            price: new_price
          }
        end

        it 'returns 400 with the correct error message' do
          results = subject.call
          expect(results[:status]).to eq :bad_request

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:code][0]).to eq 'has already been taken'

          one, two = Product.all

          expect(one.code).to eq mug.code
          expect(one.price).to eq mug.price
          expect(one.name).to eq mug.name

          expect(two.code).to eq tshirt.code
          expect(two.price).to eq tshirt.price
          expect(two.name).to eq tshirt.name
        end
      end

      context 'with a poor json request' do
        let(:attributes) { nil }

        it 'returns 400 with the correct error message' do
          results = subject.call
          expect(results[:status]).to eq :bad_request

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:error][0]).to eq 'Invalid request data'
          product = Product.find_by(code: mug.code)

          expect(product.price).to eq mug.price
          expect(product.name).to eq mug.name
        end
      end

      context 'with no such code in the DB' do
        let(:attributes) do
          {
            price: new_price
          }
        end
        let(:code) { 'CAR' }

        it 'returns 400 with the correct error message' do
          results = subject.call
          expect(results[:status]).to eq :bad_request

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:code][0]).to eq 'Product not found'

          product = Product.find_by(code: code)
          expect(product).to be_nil
        end
      end
    end
  end
end
