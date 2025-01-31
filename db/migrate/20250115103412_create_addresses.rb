# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.string :country, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :zip_code, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
