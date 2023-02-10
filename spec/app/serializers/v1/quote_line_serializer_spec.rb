# frozen_string_literal: true

module Api
  module V1
    RSpec.describe QuoteLineSerializer, type: :serializer do
      subject { described_class.new(quote_line) }

      let(:mug) { create(:product, code: 'MUG', name: 'Reedsy Mug', price: 6.00) }
      let(:quote_line) { QuoteLine.new(code: mug.code, qty: 23) }
      let(:discount) { 0.3 }

      before do
        allow_any_instance_of(::QuoteLine)
          .to receive(:discount_percentage)
          .and_return(1 - discount)
      end

      context 'when quote_line is serialized' do
        it { is_expected.to have_type(:QuoteLine) }
        it { is_expected.to serialize_attribute(:code).as(quote_line.code) }
        it { is_expected.to serialize_attribute(:qty).as(quote_line.qty) }
        it { is_expected.to serialize_attribute(:product_price).as(mug.price) }
        it { is_expected.to serialize_attribute(:line_price).as(mug.price * (1 - discount)) }
        it { is_expected.to serialize_attribute(:discount_percentage).as(30) }
        it { is_expected.to serialize_attribute(:total_price).as(mug.price * quote_line.qty * (1 - discount)) }
      end
    end
  end
end
