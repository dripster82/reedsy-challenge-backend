# frozen_string_literal: true

module Api
  module V1
    RSpec.describe QuoteSerializer, type: :serializer do
      subject { described_class.new(quote) }

      let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
      let(:tshirt) { create(:product, code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }
      let(:line_qty) { 2 }
      let(:total_price) { ((mug.price * line_qty) + (tshirt.price * line_qty)) }
      let(:quote_lines) do
        [
          QuoteLine.new(code: mug.code, qty: line_qty),
          QuoteLine.new(code: tshirt.code, qty: line_qty)
        ]
      end
      let(:quote) { Quote.new(quote_lines: quote_lines) }

      context 'when quote is serialized' do
        it { is_expected.to have_type(:Quote) }
        it { is_expected.to serialize_attribute(:total_price).as(total_price) }
        it { is_expected.to have_many(:quote_lines).serializer(Api::V1::QuoteLineSerializer) }
      end
    end
  end
end
