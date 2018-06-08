# frozen_string_literal: true

class AddCalendarAccessTokenToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :calendar_access_token, :string
  end
end
