# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject { described_class.new(quote_lines: quote_lines) }

  let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
  let(:tshirt) { create(:product, code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }
  let(:hoodie) { create(:product, code: 'HOODIE', name: 'Reedsy Hoodie', price: 20.00) }
  let(:quote_lines) { [] }

  context 'when initialized' do
    it 'quote_lines should return an empty array' do
      expect(subject.quote_lines).to eq []
    end

    context 'with quote lines' do
      let(:qty) { 3 }

      before do
        quote_lines << QuoteLine.new(code: mug.code, qty: qty)
      end

      it 'adds the quote_lines to the quote' do
        expect(subject.quote_lines.size).to eq 1
        expect(subject.quote_lines[0].code).to eq mug.code
        expect(subject.quote_lines[0].qty).to eq qty
      end
    end
  end

  describe '.total_price' do
    let(:mug_qty) { 3 }
    let(:hoodie_qty) { 2 }
    let(:total_price) { (mug.price * mug_qty) + (hoodie.price * hoodie_qty) }

    before do
      quote_lines << QuoteLine.new(code: mug.code, qty: mug_qty)
      quote_lines << QuoteLine.new(code: hoodie.code, qty: hoodie_qty)
    end

    context 'with two quote lines' do
      it 'provides the correct total price' do
        expect(subject.total_price).to eq total_price
      end
    end
  end

  context 'with no quote lines' do
    it 'is invalid' do
      expect(subject).not_to be_valid
    end
  end

  context 'with quote lines' do
    before do
      quote_lines << QuoteLine.new(code: mug.code, qty: 1)
    end

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
