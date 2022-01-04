# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer do
  describe '#no_reset' do
    subject(:mail) { described_class.no_reset(user) }

    let(:user) { build(:user) }

    it 'is addressed to the user' do
      expect(mail.to).to eq([user.email])
    end

    context 'with an invited user' do
      let(:user) { create :user, :invited }

      it 'says why in the body' do
        expect(mail.body.encoded).to match(/haven't yet accepted your invitation/)
      end
    end

    context 'with a user using OAuth' do
      let!(:provider) do
        OauthProvider.new(:test, 'Test', 'test', 'test_id', 'test_secret')
      end
      let(:user) { build :user, :oauth }

      it 'says why in the body' do
        expect(mail.body.encoded).to match(/associated with your #{provider.name} account/)
      end
    end
  end
end
