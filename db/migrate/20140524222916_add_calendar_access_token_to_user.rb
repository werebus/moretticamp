# frozen_string_literal: true

class AddCalendarAccessTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :calendar_access_token, :string
  end
end
