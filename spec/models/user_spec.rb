# frozen_string_literal: true

require 'rails_helper'
require_relative '../concerns/date_range'

RSpec.describe User do
  describe '.find_for_oauth' do
    let! :user do
      create :user, provider: 'test', uid: 'user@test.local'
    end
    let :auth do
      OpenStruct.new(provider: 'test', uid: 'user@test.local')
    end
    it 'finds a user given an auth object' do
      expect(User.find_for_oath(auth)).to eq user
    end
  end

  describe '.to_notify' do
    before :each do
      create :user, email_updates: true
      create :user, email_updates: false
    end
    it 'finds users who want to be notified' do
      expect(User.to_notify.count).to be 1
    end
    it 'finds all users if told to' do
      expect(User.to_notify(true).count).to be 2
    end
  end

  describe '#full_name' do
    it 'has both names' do
      user = build :user, first_name: 'Primus', last_name: 'Ultimus'
      expect(user.full_name).to include('Primus')
      expect(user.full_name).to include('Ultimus')
    end
  end

  describe '#invitation_limit and #invitations?' do
    let :non_admin_without_invites do
      create :user, invitation_limit: nil
    end
    let :non_admin_with_invites do
      create :user, invitation_limit: 1
    end
    let :admin do
      create :user, admin: true
    end

    it 'never runs out for admins' do
      expect(admin.invitation_limit).to eq Float::INFINITY
      expect(admin.invitations?).to be true
    end
    it 'passes through for non-admins, false for non-positive numbers' do
      expect(non_admin_without_invites.invitation_limit).to be_nil
      expect(non_admin_without_invites.invitations?).to be false
    end
    it 'passes through for non-admins, true for positive numbers' do
      expect(non_admin_with_invites.invitation_limit).to be 1
      expect(non_admin_with_invites.invitations?).to be true
    end
  end

  describe '#send_reset_password_instructions' do
    let :password_user do
      create :user
    end
    let :invited_user do
      user = build :user, :invited
      user.invite! do |u|
        u.skip_invitation = true
      end
      user
    end
    let :oauth_user do
      user = build :user, :oauth
      user.invite! do |u|
        u.skip_invitation = true
      end
      user.accept_invitation!
      user
    end
    let :mail do
      OpenStruct.new(deliver: true, deliver_now: true, deliver_later: true)
    end

    it 'sends a reset email if there is no reason not to' do
      expect(password_user)
        .to receive(:send_reset_password_instructions_notification)
      password_user.send_reset_password_instructions
    end
    it 'does not reset the password if an invitation is pending' do
      expect(UserMailer)
        .to receive(:no_reset)
        .with(invited_user, :invited)
        .and_return(mail)
      invited_user.send_reset_password_instructions
    end
    it 'does not reset the password if oauth is configured' do
      expect(UserMailer)
        .to receive(:no_reset)
        .with(oauth_user, :oauth)
        .and_return(mail)
      oauth_user.send_reset_password_instructions
    end
  end

  describe '#generate_calendar_access_token' do
    let :new_user do
      build :user
    end
    let :existing_user do
      create :user
    end

    it 'generates a token for new users' do
      expect(new_user.calendar_access_token).to be_blank
      new_user.save
      expect(new_user.calendar_access_token).not_to be_blank
    end
    it 'regenerates a token when blanked' do
      old_token = existing_user.calendar_access_token
      existing_user.update_attributes(calendar_access_token: nil)
      expect(existing_user.calendar_access_token).not_to be_blank
      expect(existing_user.calendar_access_token).not_to eq(old_token)
    end
  end
end
