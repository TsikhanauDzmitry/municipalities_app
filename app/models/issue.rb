# frozen_string_literal: true

class Issue < ApplicationRecord
  enum :status, { open: 0, accepted: 1, in_progress: 2, rejected: 3, closed: 4 }
  enum :priority, { low: 0, medium: 1, high: 2 }

  belongs_to :creator, class_name: 'User', foreign_key: :created_by
  belongs_to :worker, class_name: 'User', optional: true

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :preview, resize_to_limit: [200, 300]
    attachable.variant :large, resize_to_limit: [600, 900]
  end

  validates :title, :description, :status, :priority, presence: true
  validates :image, content_type: %w[image/png image/jpeg image/jpg], size: { less_than: 5.megabytes }
end
