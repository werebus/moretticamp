# frozen_string_literal: true

namespace :seasons do
  desc 'Set "avaiable" value for past seasons'
  task set_available: :environment do
    Season.where(available: nil).find_each do |season|
      season.update(available: season.start_date)
    end
  end
end
