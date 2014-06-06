require 'csv'

namespace :invite do
  desc "Invites a user to the site"
  task :user, [:email, :last_name, :first_name] => [:environment] do |t,args|
    Inviter.invite! args
  end

  desc "Invite a CSV of users to the site"
  task :userlist, [:filename] => [:environment] do |t,args|
    CSV.foreach(args[:filename], headers: true) do |row|
      Inviter.invite! row.to_hash.symbolize_keys
    end
  end
end

module Inviter
  def self.invite!(data)
    User.invite!(email: data[:email], last_name: data[:last_name], first_name: data[:first_name])
  end
end
