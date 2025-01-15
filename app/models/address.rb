# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :country, :city, :street, :zip_code, presence: true
end
