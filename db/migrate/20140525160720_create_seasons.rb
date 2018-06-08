# frozen_string_literal: true

class CreateSeasons < ActiveRecord::Migration[4.2]
  def change
    create_table :seasons do |t|
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
