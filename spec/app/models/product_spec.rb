# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Product', type: :model do
  describe '#code' do
    it 'can initialise code' do
      product = Product.new(code: 'TSHIRT')
      expect(product.code).to eq 'TSHIRT'
    end
  end

  describe '#name' do
    it 'can initialise name' do
      product = Product.new(name: 'Reedsy T-Shirt')
      expect(product.name).to eq 'Reedsy T-Shirt'
    end
  end

  describe '#price' do
    it 'can initialise price' do
      product = Product.new(price: 15.00)
      expect(product.price).to eq 15.00
    end
  end

  describe '.valid?' do
    context 'when it has all valid values' do
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }

      it 'returns true' do
        expect(product).to be_valid
      end
    end

    context 'when the code is blank' do
      let(:product) { Product.new(code: '', name: 'Reedsy Bag', price: 17.99) }

      it 'returns false' do
        expect(product).not_to be_valid
      end
    end

    context 'when the code is not unique' do
      let(:existing_product) { create(:product, code: 'BAG', name: 'Reedsy Bag', price: 17.99) }
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }

      before do
        existing_product
      end

      it 'returns false' do
        expect(product).not_to be_valid
      end
    end

    context 'when the name is blank' do
      let(:product) { Product.new(code: 'BAG', name: '', price: 17.99) }

      it 'returns false' do
        expect(product).not_to be_valid
      end
    end

    context 'when the price is set to nil' do
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: nil) }

      it 'returns false' do
        expect(product).not_to be_valid
      end
    end

    context 'when the price is not present' do
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag') }

      it 'returns true' do
        expect(product).to be_valid
      end
    end

    context 'when the price is positive' do
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: 17.99) }

      it 'returns true' do
        expect(product).to be_valid
      end
    end

    context 'when the price is negative' do
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag', price: -17.99) }

      it 'returns false' do
        expect(product).not_to be_valid
      end
    end

    context 'when the price passed a string' do
      let(:product) { Product.new(code: 'BAG', name: 'Reedsy Bag') }

      it "returns false for 'ABD'" do
        product.price = 'ABC'

        expect(product).not_to be_valid
      end

      it "returns true for '12.99'" do
        product.price = '12.99'
        expect(product).to be_valid
      end
    end
  end

  describe '.all' do
    let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
    let(:tshirt) { create(:product, code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }

    before do
      mug
      tshirt
    end

    it 'will return products' do
      results = Product.all

      expect(results.count).to eq 2
      one, two = results

      expect(one.code).to eq mug.code
      expect(one.name).to eq mug.name
      expect(one.price).to eq mug.price

      expect(two.code).to eq tshirt.code
      expect(two.name).to eq tshirt.name
      expect(two.price).to eq tshirt.price
    end
  end
end
