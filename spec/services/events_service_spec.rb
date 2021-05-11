# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsService do
  describe '.find' do
    let :date_params do
      ActiveSupport::HashWithIndifferentAccess.new(
        start: '2018-01-01',
        end: '2018-12-31'
      )
    end

    it 'finds events between two dates if given them' do
      expect(Event)
        .to receive(:between)
        .with(Date.new(2018, 1, 1), Date.new(2018, 12, 31))
        .and_call_original
      described_class.find(date_params)
    end

    it 'finds all events if there aren\'t both dates' do
      # #includes delegates to #all
      expect(Event).to receive(:all).and_call_original
      described_class.find({})
    end

    it 'includes the users' do
      expect(Event).to receive(:includes).with(:user).and_call_original
      described_class.find({})
    end
  end
end
