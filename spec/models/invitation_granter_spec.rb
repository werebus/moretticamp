# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitationGranter do
  let(:user) { create :user }

  describe 'validations' do
    it 'requires users' do
      expect(described_class.new(user_ids: [])).not_to be_valid
    end

    it 'requires a positive quantity' do
      expect([nil, 0, -2].map { described_class.new(user_ids: [user.id], quantity: it) }).to all(be_invalid)
    end
  end

  describe '#user_ids=' do
    it 'handles blanks and strings' do
      granter = described_class.new
      granter.user_ids = [1, nil, '', '5']
      expect(granter.user_ids).to contain_exactly(1, 5)
    end
  end

  describe '#users' do
    subject(:call) { described_class.new(user_ids: [user.id]).users }

    it { is_expected.to be_a(ActiveRecord::Relation) }

    it 'is a collection of users for its ids' do
      expect(call).to eq(User.where(id: user.id))
    end
  end

  describe '#grant!' do
    subject(:call) { granter.grant! }

    let(:granter) { described_class.new(user_ids: [user.id], quantity: 5) }

    before { user.update!(invitation_limit: 2) }

    it 'validates' do
      allow(granter).to receive(:validate!)
      call
      expect(granter).to have_received(:validate!)
    end

    it "increments users' invitation limit" do
      expect { call }.to change { user.reload.invitation_limit }.by(5)
    end

    it "doesn't try to update admin users" do
      user.update! admin: true
      allow(user).to receive(:update!)
      call
      expect(user).not_to have_received(:update!)
    end

    context 'with an invalid user' do
      let(:invalid_user) { build :user, first_name: nil, last_name: nil }

      before { allow(granter).to receive(:users).and_return([user, invalid_user]) }

      it 'passes along the exception' do
        expect { call }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'merges in validation errors on the user' do
        call
      rescue ActiveRecord::RecordInvalid
        expect(granter.errors).to have_key(:first_name)
      end
    end
  end

  describe '#status' do
    subject(:call) { described_class.new(user_ids: [user.id], quantity: 77).status }

    it 'has a count' do
      expect(call.fetch(:count)).to eq(1)
    end

    it 'has a quatity' do
      expect(call.fetch(:quantity)).to eq(77)
    end
  end
end
