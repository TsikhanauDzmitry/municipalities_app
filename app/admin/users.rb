# frozen_string_literal: true

ActiveAdmin.register User do
  actions :all
  permit_params :email, :password, :password_confirmation, :role

  filter :email
  filter :created_at
  filter :role, as: :select, collection: User.roles.keys

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :created_at
      row :updated_at
      row :role
    end
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :roles, as: :check_boxes, collection: User.roles.keys
    end
    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      super
    end
  end
end
