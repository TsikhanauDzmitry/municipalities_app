ActiveAdmin.register Address do
  actions :all
  permit_params :user_id, :country, :city, :state, :street, :zip_code

  filter :user_id, as: :select, collection: -> { User.all.map { |u| [u.email, u.id] } }
  filter :country
  filter :city

  index do
    selectable_column
    id_column
    column(:user) { |address| address.user.email }
    column :country
    column :city
    column :street
    column :zip_code
    column :created_at
    actions
  end

  show do
    attributes_table do
      row(:user) { |address| address.user.email }
      row :country
      row :city
      row :street
      row :zip_code
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :user, collection: User.all.map { |u| [u.email, u.id] }
      # f.input :country
      f.input :city
      f.input :street
      f.input :zip_code
    end
    f.actions
  end
end
