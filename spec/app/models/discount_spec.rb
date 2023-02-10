# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe '#qty' do
    let(:discount) { described_class.new(qty: qty) }
    let(:qty) { 1 }

    it 'can initialise qty' do
      expect(discount.qty).to eq qty
    end
  end

  describe '#discount' do
    let(:discount) { described_class.new(discount: discount_percentage) }
    let(:discount_percentage) { 0.34 }

    it 'can initialise discount' do
      expect(discount.discount).to eq discount_percentage
    end
  end

  describe '#product' do
    let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
    let(:discount) { described_class.new(product: product) }

    it 'can initialise discount' do
      expect(discount.product.code).to eq product.code
    end
  end

  describe '.valid?' do
    context 'when it has all valid values' do
      let(:discount) { described_class.new(product: product, qty: qty, discount: discount_percentage) }
      let(:discount_percentage) { 0.34 }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
      let(:qty) { 1 }

      it 'returns true' do
        expect(discount).to be_valid
      end
    end

    context 'when it has the product missing' do
      let(:discount) { described_class.new(qty: qty, discount: discount_percentage) }
      let(:discount_percentage) { 0.34 }
      let(:qty) { 1 }

      it 'returns false' do
        expect(discount).not_to be_valid
      end
    end

    context 'when it has the qty missing' do
      let(:discount) { described_class.new(product: product, discount: discount_percentage) }
      let(:discount_percentage) { 0.34 }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }

      it 'returns false' do
        expect(discount).not_to be_valid
      end
    end

    context 'when it has the discount missing' do
      let(:discount) { described_class.new(product: product, qty: qty) }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
      let(:qty) { 1 }

      it 'returns true' do
        expect(discount).not_to be_valid
      end
    end

    context 'when it has the qty is negative' do
      let(:discount) { described_class.new(product: product, qty: qty, discount: discount_percentage) }
      let(:discount_percentage) { 0.34 }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
      let(:qty) { -1 }

      it 'returns true' do
        expect(discount).not_to be_valid
      end
    end

    context 'when it has the discount is below minimum value (0.1%)' do
      let(:discount) { described_class.new(product: product, qty: qty, discount: discount_percentage) }
      let(:discount_percentage) { 0.000 }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
      let(:qty) { 1 }

      it 'returns true' do
        expect(discount).not_to be_valid
      end
    end

    context 'when it has the discount greater than 100%' do
      let(:discount) { described_class.new(product: product, qty: qty, discount: discount_percentage) }
      let(:discount_percentage) { 1.001 }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
      let(:qty) { 1 }

      it 'returns true' do
        expect(discount).not_to be_valid
      end
    end
  end
end
