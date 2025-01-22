# frozen_string_literal: true

class AddNotificationDefault < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :email_updates, from: nil, to: false
  end
end
