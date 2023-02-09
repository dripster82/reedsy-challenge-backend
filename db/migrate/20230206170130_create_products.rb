# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code, null: false, index: { unique: true, name: 'unique_codes' }
      t.string :name, null: false
      t.decimal :price, precision: 9, scale: 2, default: 0.0, unsigned: true

      t.timestamps
    end
  end
end
