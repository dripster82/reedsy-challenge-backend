# frozen_string_literal: true

module Api
  module V1
    class ProductSerializer
      include JSONAPI::Serializer

      attributes :code, :name, :price

      set_id :code
      set_key_transform :camel
    end
  end
end
