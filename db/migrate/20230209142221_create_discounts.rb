# frozen_string_literal: true

class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :qty, null: false
      t.decimal :discount, precision: 4, scale: 3, null: false, unsinged: true

      t.timestamps
    end
  end
end
