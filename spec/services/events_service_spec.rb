# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsService do
  describe '.find' do
    subject(:call) { described_class.find(params) }

    let(:params) { {} }

    it 'includes the users' do
      allow(Event).to receive(:includes).and_call_original
      call
      expect(Event).to have_received(:includes).with(:user)
    end

    context 'when given two dates' do
      let(:params) do
        ActiveSupport::HashWithIndifferentAccess.new(start: '2018-01-01', end: '2018-12-31')
      end

      it 'finds events between them' do
        allow(Event).to receive(:between).and_call_original
        call
        expect(Event).to have_received(:between)
          .with(Date.new(2018, 1, 1), Date.new(2018, 12, 31))
      end
    end

    context 'when not given two dates' do
      it 'finds all events' do
        # #includes delegates to #all
        allow(Event).to receive(:all).and_call_original
        call
        expect(Event).to have_received(:all)
      end
    end
  end
end
