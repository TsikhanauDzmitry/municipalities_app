# frozen_string_literal: true

class CreateIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :issues do |t|
      t.string :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.integer :created_by, null: false
      t.integer :worker_id
      t.integer :status, null: false, default: 0
      t.integer :priority, null: false, default: 0

      t.timestamps
    end
  end
end
