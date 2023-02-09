# frozen_string_literal: true

module Api
  module V1
    RSpec.describe ProductSerializer, type: :serializer do
      subject { described_class.new(product) }

      let(:product) { Product.new(code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00) }

      context 'when product is serialized' do
        it { is_expected.to have_type(:Product) }
        it { is_expected.to serialize_attribute(:code).as(product.code) }
        it { is_expected.to serialize_attribute(:name).as(product.name) }
        it { is_expected.to serialize_attribute(:price).as(product.price) }
      end
    end
  end
end
