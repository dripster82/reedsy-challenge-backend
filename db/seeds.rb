# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

mug = Product.create({ code: 'MUG', name: 'Reedsy Mug', price: 6.00 })
tshirt = Product.create({ code: 'TSHIRT', name: 'Reedsy T-Shirt', price: 15.00 })
Product.create({ code: 'HOODIE', name: 'Reedsy Hoodie', price: 20.00 })

Discount.create({ product: tshirt, qty: 3, discount: 0.3 })
(1..15).each do |i|
  Discount.create({ product: mug, qty: (i * 10), discount: (i * 0.02) })
end
