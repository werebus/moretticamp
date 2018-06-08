# frozen_string_literal: true

class AddEmailUpdatesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_updates, :boolean
  end
end
