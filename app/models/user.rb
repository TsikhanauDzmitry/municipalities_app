# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum :role, {
    resident: 0,
    employee: 1,
    admin: 2
  }

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  has_one :profile, dependent: :destroy
  has_one :address, dependent: :destroy

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :address
end
