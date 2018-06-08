# frozen_string_literal: true

class AddTitleToEvent < ActiveRecord::Migration
  def change
    add_column :events, :title, :string
  end
end
