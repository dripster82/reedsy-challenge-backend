# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuoteLine, type: :model do
  subject { described_class.new(code: code, qty: qty) }

  let(:product) { create(:product, code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
  let(:code) { product.code }
  let(:qty) { 5 }

  context 'when valid data is passed' do
    it 'has the correct attribute values' do
      expect(subject.qty).to eq qty
      expect(subject.code).to eq product.code
      expect(subject.product_price).to eq product.price
      expect(subject.line_price).to eq product.price
      expect(subject.total_price).to eq product.price * qty
      expect(subject.discount_percentage).to eq 1
      expect(subject).to be_valid
    end

    context 'when a discount exists' do
      let(:discount) { create(:discount, product: product, qty: 3, discount: 0.3) }

      before do
        discount
        create(:discount, product: product, qty: 30, discount: 0.4)
      end

      it 'has the correct discount' do
        discount_val = (1 - discount.discount)
        expect(subject.discount_percentage).to eq discount_val
        expect(subject.line_price).to eq product.price *  discount_val
        expect(subject.total_price).to eq product.price * qty * discount_val
        expect(subject).to be_valid
      end
    end
  end

  context 'when invalid data is passed' do
    context 'with a negative qty' do
      let(:qty) { -3 }

      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'with an invalid product code' do
      let(:code) { 'CAR' }

      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end
  end
end
