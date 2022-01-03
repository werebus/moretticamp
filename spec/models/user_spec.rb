# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '.find_for_oauth' do
    let!(:user) { create :user, :oauth }
    let(:auth) { Hashie::Mash.new(provider: 'test', uid: 'user@test.local') }

    it 'finds a user given an auth object' do
      expect(described_class.find_for_oauth(auth)).to eq(user)
    end
  end

  describe '.to_notify' do
    before do
      create :user, email_updates: true
      create :user, email_updates: false
    end

    it 'finds users who want to be notified' do
      expect(described_class.to_notify.count).to be 1
    end

    it 'finds all users if told to' do
      expect(described_class.to_notify(override: true).count).to be 2
    end
  end

  describe '#full_name' do
    subject(:full_name) { user.full_name }

    let(:user) { build :user, first_name: 'Primus', last_name: 'Ultimus' }

    it { is_expected.to include('Primus') }

    it { is_expected.to include('Ultimus') }
  end

  describe '#invitation_limit' do
    it 'never runs out for admins' do
      user = create :user, admin: true
      expect(user.invitation_limit).to eq Float::INFINITY
    end

    it 'passes through for non-admins without invitations' do
      user = create :user, invitation_limit: nil
      expect(user.invitation_limit).to be_nil
    end

    it 'passes through for non-admins with invitations' do
      user = create :user, invitation_limit: 1
      expect(user.invitation_limit).to be 1
    end
  end

  describe '#invitations?' do
    it 'returns true for admins' do
      user = create :user, admin: true
      expect(user.invitations?).to be true
    end

    it 'returns false for non-admins without invitations' do
      user = create :user, invitation_limit: nil
      expect(user.invitations?).to be false
    end

    it 'returns true for non-admins with invitations' do
      user = create :user, invitation_limit: 2
      expect(user.invitations?).to be true
    end
  end

  describe '#provider_name' do
    let!(:provider) do
      OauthProvider.new(:test, 'Test', 'test', 'test_id', 'test_secret')
    end

    it "is the name of the user's provider" do
      user = build(:user, provider: 'test')
      expect(user.provider_name).to eq(OauthProvider[:test].name)
    end

    it "is nil if the user's provider is nil" do
      expect(build(:user).provider_name).to be_nil
    end
  end

  describe '#send_reset_password_instructions' do
    let(:password_user) { create :user }
    let(:invited_user) { create :user, :invited }
    let(:oauth_user) { create :user, :oauth }

    before do
      allow(UserMailer).to receive(:no_reset).and_call_original
    end

    it 'sends a reset email if there is no reason not to' do
      allow(password_user).to receive(:send_reset_password_instructions_notification)
      password_user.send_reset_password_instructions
      expect(password_user).to have_received(:send_reset_password_instructions_notification)
    end

    it 'does not reset the password if an invitation is pending' do
      invited_user.send_reset_password_instructions
      expect(UserMailer).to have_received(:no_reset).with(invited_user)
    end

    it 'does not reset the password if oauth is configured' do
      oauth_user.send_reset_password_instructions
      expect(UserMailer).to have_received(:no_reset).with(oauth_user)
    end
  end

  describe '#generate_calendar_access_token' do
    subject(:call) { user.calendar_access_token }

    context 'with a new user' do
      let(:user) { build :user }

      it { is_expected.to be_blank }

      it 'generates a token on save' do
        user.save
        expect(call).to be_present
      end
    end

    context 'with a existing user' do
      let(:user) { create :user }

      it 'regenerates a token when blanked' do
        user.update(calendar_access_token: nil)
        expect(user.calendar_access_token).to be_present
      end

      it 'changes the token when blanked' do
        old_token = user.calendar_access_token
        user.update(calendar_access_token: nil)
        expect(user.calendar_access_token).not_to eq(old_token)
      end
    end
  end
end
