# frozen_string_literal: true

require 'rails_helper'
require 'jsonapi'
module Products
  RSpec.describe QuoteService do
    subject { described_class.new(quote_lines: quote_lines) }

    let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
    let(:tshirt) { create(:product, code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }
    let(:hoodie) { create(:product, code: 'HOODIE', name: 'Reedsy Hoodie', price: 20.00) }

    let(:quote_lines) { [] }

    context 'when sent valid data' do
      context 'when passed a single product line' do
        let(:total_price) { (mug.price * mug_qty).to_s }
        let(:mug_qty) { 2 }

        before do
          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: mug_qty } }
        end

        it 'returns the correct quote object and status' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship = json_data[:data][:relationships][:quote_lines][:data][0]

          expect(relationship[:id]).to eq mug.code
          expect(relationship[:type]).to eq 'QuoteLine'

          quote_line = json_data[:included][0]

          expect(quote_line[:id]).to eq mug.code
          expect(quote_line[:type]).to eq 'QuoteLine'
          expect(quote_line[:attributes][:qty]).to eq mug_qty
          expect(quote_line[:attributes][:product_price]).to eq mug.price.to_s
          expect(quote_line[:attributes][:line_price]).to eq mug.price.to_s
          expect(quote_line[:attributes][:total_price]).to eq total_price.to_s
        end
      end

      context 'when passed a multiple product lines' do
        let(:total_price) { (mug_total_price + tshirt_total_price).to_s }
        let(:mug_total_price) { mug.price * mug_qty }
        let(:tshirt_total_price) { tshirt.price * tshirt_qty }
        let(:mug_qty) { 1 }
        let(:tshirt_qty) { 2 }

        before do
          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: mug_qty } }
          quote_lines << { id: tshirt.code, type: 'QuoteLine', attributes: { qty: tshirt_qty } }
        end

        it 'returns the correct quote object and status' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship_one, relationship_two = json_data[:data][:relationships][:quote_lines][:data]

          expect(relationship_one[:id]).to eq mug.code
          expect(relationship_one[:type]).to eq 'QuoteLine'
          expect(relationship_two[:id]).to eq tshirt.code
          expect(relationship_two[:type]).to eq 'QuoteLine'

          quote_line_one, quote_line_two = json_data[:included]

          expect(quote_line_one[:id]).to eq mug.code
          expect(quote_line_one[:type]).to eq 'QuoteLine'
          expect(quote_line_one[:attributes][:qty]).to eq mug_qty
          expect(quote_line_one[:attributes][:product_price]).to eq mug.price.to_s
          expect(quote_line_one[:attributes][:line_price]).to eq mug.price.to_s
          expect(quote_line_one[:attributes][:total_price]).to eq mug_total_price.to_s

          expect(quote_line_two[:id]).to eq tshirt.code
          expect(quote_line_two[:type]).to eq 'QuoteLine'
          expect(quote_line_two[:attributes][:qty]).to eq tshirt_qty
          expect(quote_line_two[:attributes][:product_price]).to eq tshirt.price.to_s
          expect(quote_line_two[:attributes][:line_price]).to eq tshirt.price.to_s
          expect(quote_line_two[:attributes][:total_price]).to eq tshirt_total_price.to_s
        end
      end

      context 'when passed a multiple product lines with matching codes' do
        let(:total_price) { (mug_total_price + tshirt_total_price).to_s }
        let(:mug_total_price) { mug.price * mug_qty }
        let(:tshirt_total_price) { tshirt.price * (tshirt_qty * 2) }
        let(:mug_qty) { 1 }
        let(:tshirt_qty) { 2 }

        before do
          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: mug_qty } }
          quote_lines << { id: tshirt.code, type: 'QuoteLine', attributes: { qty: tshirt_qty } }
          quote_lines << { id: tshirt.code, type: 'QuoteLine', attributes: { qty: tshirt_qty } }
        end

        it 'returns the correct quote object and status' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship_one, relationship_two = json_data[:data][:relationships][:quote_lines][:data]

          expect(relationship_one[:id]).to eq mug.code
          expect(relationship_one[:type]).to eq 'QuoteLine'
          expect(relationship_two[:id]).to eq tshirt.code
          expect(relationship_two[:type]).to eq 'QuoteLine'

          quote_line_one, quote_line_two = json_data[:included]

          expect(quote_line_one[:id]).to eq mug.code
          expect(quote_line_one[:type]).to eq 'QuoteLine'
          expect(quote_line_one[:attributes][:qty]).to eq mug_qty
          expect(quote_line_one[:attributes][:product_price]).to eq mug.price.to_s
          expect(quote_line_one[:attributes][:line_price]).to eq mug.price.to_s
          expect(quote_line_one[:attributes][:total_price]).to eq mug_total_price.to_s

          expect(quote_line_two[:id]).to eq tshirt.code
          expect(quote_line_two[:type]).to eq 'QuoteLine'
          expect(quote_line_two[:attributes][:qty]).to eq tshirt_qty * 2
          expect(quote_line_two[:attributes][:product_price]).to eq tshirt.price.to_s
          expect(quote_line_two[:attributes][:line_price]).to eq tshirt.price.to_s
          expect(quote_line_two[:attributes][:total_price]).to eq tshirt_total_price.to_s
        end
      end
    end

    context 'when sent invalid data' do
      context 'when passed no quote lines' do
        it 'returns the correct status and error message' do
          results = subject.call
          expect(results[:status]).to eq :bad_request
          # expect(results[:json]).to eq :bad_request
        end
      end

      context 'when invalid product code is passed' do
        before do
          quote_lines << { id: 'CAR', type: 'QuoteLine', attributes: { qty: 2 } }
        end

        it 'returns the correct status and error message' do
          results = subject.call
          expect(results[:status]).to eq :bad_request
          # expect(results[:json]).to eq :bad_request
        end
      end

      context 'when a negative qty is passed' do
        before do
          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: -2 } }
        end

        it 'returns the correct status and error message' do
          results = subject.call
          expect(results[:status]).to eq :bad_request
          # expect(results[:json]).to eq :bad_request
        end
      end

      context 'when a multiple lines with a duplicate having a negative qty is passed' do
        let(:total_price) { (mug_total_price + tshirt_total_price).to_s }
        let(:mug_total_price) { mug.price * mug_qty }
        let(:tshirt_total_price) { tshirt.price * tshirt_qty }
        let(:mug_qty) { 3 }
        let(:tshirt_qty) { 2 }

        before do
          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: mug_qty } }
          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: -2 } }
          quote_lines << { id: tshirt.code, type: 'QuoteLine', attributes: { qty: tshirt_qty } }
        end

        it 'returns the correct status and error message' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship_one, relationship_two = json_data[:data][:relationships][:quote_lines][:data]

          expect(relationship_one[:id]).to eq mug.code
          expect(relationship_one[:type]).to eq 'QuoteLine'
          expect(relationship_two[:id]).to eq tshirt.code
          expect(relationship_two[:type]).to eq 'QuoteLine'

          quote_line_one, quote_line_two = json_data[:included]

          expect(quote_line_one[:id]).to eq mug.code
          expect(quote_line_one[:type]).to eq 'QuoteLine'
          expect(quote_line_one[:attributes][:qty]).to eq mug_qty
          expect(quote_line_one[:attributes][:product_price]).to eq mug.price.to_s
          expect(quote_line_one[:attributes][:line_price]).to eq mug.price.to_s
          expect(quote_line_one[:attributes][:total_price]).to eq mug_total_price.to_s

          expect(quote_line_two[:id]).to eq tshirt.code
          expect(quote_line_two[:type]).to eq 'QuoteLine'
          expect(quote_line_two[:attributes][:qty]).to eq tshirt_qty
          expect(quote_line_two[:attributes][:product_price]).to eq tshirt.price.to_s
          expect(quote_line_two[:attributes][:line_price]).to eq tshirt.price.to_s
          expect(quote_line_two[:attributes][:total_price]).to eq tshirt_total_price.to_s
        end
      end
    end

    context 'when discounts are being used' do
      context 'when a flat 30% discount is being used' do
        let(:tshirt_discount) { create(:discount, product: tshirt, qty: 3, discount: discount_percentage) }
        let(:discount_percentage) { 0.3 }
        let(:total_price) { (tshirt_line_price * tshirt_qty).to_s }
        let(:tshirt_line_price) { tshirt.price * (1 - discount_percentage) }
        let(:tshirt_qty) { 20 }

        before do
          tshirt_discount
          quote_lines << { id: tshirt.code, type: 'QuoteLine', attributes: { qty: tshirt_qty } }
        end

        it 'returns the correct quote values' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship = json_data[:data][:relationships][:quote_lines][:data][0]

          expect(relationship[:id]).to eq tshirt.code
          expect(relationship[:type]).to eq 'QuoteLine'

          quote_line = json_data[:included][0]

          expect(quote_line[:id]).to eq tshirt.code
          expect(quote_line[:type]).to eq 'QuoteLine'
          expect(quote_line[:attributes][:qty]).to eq tshirt_qty
          expect(quote_line[:attributes][:product_price]).to eq tshirt.price.to_s
          expect(quote_line[:attributes][:line_price]).to eq tshirt_line_price.to_s
          expect(quote_line[:attributes][:total_price]).to eq total_price
        end
      end

      context 'when a qty variable discount is being used' do
        let(:discount_increments) { 0.02 }
        let(:total_price) { (mug_line_price * mug_qty).to_s }
        let(:mug_line_price) { mug.price * (1 - ([(mug_qty / 10).floor(0), 15].min * discount_increments)) }
        let(:mug_qty) { 45 }

        before do
          (1..15).each do |i|
            create(:discount, product: mug, qty: (i * 10), discount: (i * discount_increments))
          end

          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: mug_qty } }
        end

        it 'returns the correct quote values' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship = json_data[:data][:relationships][:quote_lines][:data][0]

          expect(relationship[:id]).to eq mug.code
          expect(relationship[:type]).to eq 'QuoteLine'

          quote_line = json_data[:included][0]

          expect(quote_line[:id]).to eq mug.code
          expect(quote_line[:type]).to eq 'QuoteLine'
          expect(quote_line[:attributes][:qty]).to eq mug_qty
          expect(quote_line[:attributes][:product_price]).to eq mug.price.to_s
          expect(quote_line[:attributes][:line_price]).to eq mug_line_price.to_s
          expect(quote_line[:attributes][:total_price]).to eq total_price
        end
      end

      context 'when a multiple discounts are being used' do
        let(:discount_increments) { 0.02 }
        let(:mug_total_price) { (mug_line_price * mug_qty) }
        let(:mug_line_price) { mug.price * (1 - ([(mug_qty / 10).floor(0), 15].min * discount_increments)) }
        let(:mug_qty) { 200 }

        let(:tshirt_discount) { 0.3 }
        let(:tshirt_total_price) { (tshirt_line_price * tshirt_qty) }
        let(:tshirt_line_price) { tshirt.price * (1 - tshirt_discount) }
        let(:tshirt_qty) { 4 }

        let(:hoodie_total_price) { (hoodie.price * hoodie_qty) }
        let(:hoodie_qty) { 1 }

        let(:total_price) { (mug_total_price + tshirt_total_price + hoodie_total_price).to_s }

        before do
          (1..15).each do |i|
            create(:discount, product: mug, qty: (i * 10), discount: (i * discount_increments))
          end
          create(:discount, product: tshirt, qty: 3, discount: tshirt_discount)

          quote_lines << { id: mug.code, type: 'QuoteLine', attributes: { qty: mug_qty } }
          quote_lines << { id: tshirt.code, type: 'QuoteLine', attributes: { qty: tshirt_qty } }
          quote_lines << { id: hoodie.code, type: 'QuoteLine', attributes: { qty: hoodie_qty } }
        end

        it 'returns the correct quote values' do
          results = subject.call
          expect(results[:status]).to eq :ok

          json_data = JSON.parse(results[:json], symbolize_names: true)
          expect(json_data[:data][:attributes][:total_price]).to eq total_price
          relationship = json_data[:data][:relationships][:quote_lines][:data][0]

          expect(relationship[:id]).to eq mug.code
          expect(relationship[:type]).to eq 'QuoteLine'

          one, two, three = json_data[:included]

          expect(one[:id]).to eq mug.code
          expect(one[:type]).to eq 'QuoteLine'
          expect(one[:attributes][:qty]).to eq mug_qty
          expect(one[:attributes][:product_price]).to eq mug.price.to_s
          expect(one[:attributes][:line_price]).to eq mug_line_price.to_s
          expect(one[:attributes][:total_price]).to eq mug_total_price.to_s

          expect(two[:id]).to eq tshirt.code
          expect(two[:type]).to eq 'QuoteLine'
          expect(two[:attributes][:qty]).to eq tshirt_qty
          expect(two[:attributes][:product_price]).to eq tshirt.price.to_s
          expect(two[:attributes][:line_price]).to eq tshirt_line_price.to_s
          expect(two[:attributes][:total_price]).to eq tshirt_total_price.to_s

          expect(three[:id]).to eq hoodie.code
          expect(three[:type]).to eq 'QuoteLine'
          expect(three[:attributes][:qty]).to eq hoodie_qty
          expect(three[:attributes][:product_price]).to eq hoodie.price.to_s
          expect(three[:attributes][:line_price]).to eq hoodie.price.to_s
          expect(three[:attributes][:total_price]).to eq hoodie_total_price.to_s
        end
      end
    end
  end
end
