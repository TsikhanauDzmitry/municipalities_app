# frozen_string_literal: true

ActiveAdmin.register Issue do
  actions :all
  permit_params :title, :description, :status, :priority, :creator, :worker, :image

  filter :creator, as: :select, collection: -> { User.all.map { |u| [u.email, u.id] } }
  filter :worker, as: :select, collection: -> { User.managers.map { |u| [u.email, u.id] } }
  filter :title
  filter :status, as: :select, collection: Issue.statuses.keys
  filter :priority, as: :select, collection: Issue.priorities.keys

  index do
    selectable_column
    id_column
    column :title
    column :status
    column :priority
    column :creator
    column :worker
    column :created_at
    actions
  end

  show do
    attributes_table do
      row(:image) { |issue| image_tag(issue.image.variant(:preview)) if issue.image.attached? }
      row :title
      row :description
      row :status
      row :priority
      row :creator
      row :worker
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :image, as: :file
      f.input :status
      f.input :priority
      f.input :creator, collection: User.all.map { |u| [u.email, u.id] }
      f.input :worker, collection: User.managers.map { |u| [u.email, u.id] }
    end
    f.actions
  end
end
