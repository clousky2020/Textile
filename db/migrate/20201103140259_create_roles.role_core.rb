# frozen_string_literal: true
# This migration comes from role_core (originally 20170705174003)

class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.text :description
      t.text :permissions

      t.string :type, null: false

      t.timestamps
    end
  end
end
