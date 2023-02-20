# frozen_string_literal: true

module Api
  module V1
    class ProductSerializer
      include JSONAPI::Serializer

      attributes :code, :name

      attribute :price do |product|
        product.price.to_f
      end

      set_id :code
      set_key_transform :camel
    end
  end
end
