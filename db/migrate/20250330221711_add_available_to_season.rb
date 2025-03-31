# frozen_string_literal: true

class AddAvailableToSeason < ActiveRecord::Migration[7.2]
  def change
    add_column :seasons, :available, :datetime
  end
end
