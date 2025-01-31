# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum :role, { resident: 0, employee: 1, admin: 2 }

  has_one :profile, dependent: :destroy
  has_one :address, dependent: :destroy

  has_many :worked_issues, class_name: 'Issue', foreign_key: :worker_id
  has_many :opened_issues, class_name: 'Issue', foreign_key: :created_by

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :address

  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  scope :managers, -> { where.not(role: :resident) }
end
