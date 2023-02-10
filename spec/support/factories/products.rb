# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    code { 'BAG' }
    name { 'Reedsy Bag' }
    price { 25.99 }
    discounts { [] }
  end
end
