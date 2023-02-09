FactoryBot.define do
  factory :discount do
    product { nil }
    qty { 1 }
    discount { "0.5" }
  end
end
