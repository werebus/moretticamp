# frozen_string_literal: true

namespace :email_updates do
  desc 'Set default value for email updates'
  task set_default: :environment do
    accepted_ids = User.invitation_accepted.pluck(:id)
    User.where(id: accepted_ids).find_each { |user| user.update(email_updates: true) }
    User.where.not(id: accepted_ids).find_each { |user| user.update(email_updates: false) }
  end
end
